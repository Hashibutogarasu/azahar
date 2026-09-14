// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include <array>
#include <cstdint>
#include <dlfcn.h>
#include <unordered_map>

#include <android/input.h>
#include <paddleboat/paddleboat.h>

#include "jni/game_controller_manager.h"
#include "jni/id_cache.h"
#include "jni/input_manager.h"

namespace GameControllerManager {

namespace {

constexpr int kMaxControllers = 8;
std::array<uint32_t, kMaxControllers> g_previous_buttons{};
bool g_initialized = false;

struct StickState {
    float x = 0.f;
    float y = 0.f;
};

// Virtual (touch overlay) state, keyed by N3DS_BUTTON_*/N3DS_CIRCLEPAD/N3DS_STICK_C id.
std::unordered_map<int, bool> g_virtual_buttons;
std::unordered_map<int, StickState> g_virtual_sticks;

// Last combined (physical OR virtual) pressed state per button id, for edge detection in Update().
std::unordered_map<int, bool> g_previous_combined_buttons;

struct ButtonMapping {
    uint32_t paddleboat_mask;
    int n3ds_button_id;
};

constexpr std::array<ButtonMapping, 14> kButtonMappings{{
    {PADDLEBOAT_BUTTON_A, InputManager::N3DS_BUTTON_A},
    {PADDLEBOAT_BUTTON_B, InputManager::N3DS_BUTTON_B},
    {PADDLEBOAT_BUTTON_X, InputManager::N3DS_BUTTON_X},
    {PADDLEBOAT_BUTTON_Y, InputManager::N3DS_BUTTON_Y},
    {PADDLEBOAT_BUTTON_START, InputManager::N3DS_BUTTON_START},
    {PADDLEBOAT_BUTTON_SELECT, InputManager::N3DS_BUTTON_SELECT},
    {PADDLEBOAT_BUTTON_L1, InputManager::N3DS_TRIGGER_L},
    {PADDLEBOAT_BUTTON_R1, InputManager::N3DS_TRIGGER_R},
    {PADDLEBOAT_BUTTON_L2, InputManager::N3DS_BUTTON_ZL},
    {PADDLEBOAT_BUTTON_R2, InputManager::N3DS_BUTTON_ZR},
    {PADDLEBOAT_BUTTON_DPAD_UP, InputManager::N3DS_DPAD_UP},
    {PADDLEBOAT_BUTTON_DPAD_DOWN, InputManager::N3DS_DPAD_DOWN},
    {PADDLEBOAT_BUTTON_DPAD_LEFT, InputManager::N3DS_DPAD_LEFT},
    {PADDLEBOAT_BUTTON_DPAD_RIGHT, InputManager::N3DS_DPAD_RIGHT},
}};

using KeyEventFromJavaFn = const AInputEvent* (*)(JNIEnv*, jobject);
using MotionEventFromJavaFn = const AInputEvent* (*)(JNIEnv*, jobject);
using InputEventReleaseFn = void (*)(const AInputEvent*);

KeyEventFromJavaFn g_key_event_from_java = nullptr;
MotionEventFromJavaFn g_motion_event_from_java = nullptr;
InputEventReleaseFn g_input_event_release = nullptr;
bool g_input_bridge_resolved = false;

/**
 * AKeyEvent_fromJava/AMotionEvent_fromJava/AInputEvent_release are only introduced in API 31,
 * above this app's minSdkVersion, so the NDK refuses to link against them directly. Resolve them
 * with dlsym instead, which works regardless of the compile-time target API level; the function
 * pointers stay null (and callers no-op) on older devices.
 */
void ResolveInputEventBridge() {
    if (g_input_bridge_resolved) {
        return;
    }
    g_input_bridge_resolved = true;
    void* handle = dlopen("libandroid.so", RTLD_NOW);
    if (!handle) {
        return;
    }
    g_key_event_from_java =
        reinterpret_cast<KeyEventFromJavaFn>(dlsym(handle, "AKeyEvent_fromJava"));
    g_motion_event_from_java =
        reinterpret_cast<MotionEventFromJavaFn>(dlsym(handle, "AMotionEvent_fromJava"));
    g_input_event_release =
        reinterpret_cast<InputEventReleaseFn>(dlsym(handle, "AInputEvent_release"));
}

/**
 * InputManager::Init() only runs once the emulated core starts (inside RunCitra), which can be
 * well after auto-detect mode is enabled and doFrame() starts polling controllers.
 */
bool IsInputManagerReady() {
    return InputManager::ButtonHandler() != nullptr && InputManager::AnalogHandler() != nullptr;
}

/**
 * Notifies the Kotlin side whenever any controller connects or disconnects, so the UI can react
 * (e.g. auto-hiding the virtual controller overlay) without polling.
 */
void OnControllerStatusChanged(const int32_t controller_index,
                                const Paddleboat_ControllerStatus status, void* user_data) {
    if (status != PADDLEBOAT_CONTROLLER_JUST_CONNECTED &&
        status != PADDLEBOAT_CONTROLLER_JUST_DISCONNECTED) {
        return;
    }
    if (controller_index >= 0 && controller_index < kMaxControllers) {
        g_previous_buttons[controller_index] = 0;
    }

    JNIEnv* env = IDCache::GetEnvForThread();
    env->CallStaticVoidMethod(IDCache::GetNativeLibraryClass(),
                              IDCache::GetOnControllerConnectionChanged(),
                              static_cast<jboolean>(status ==
                                                     PADDLEBOAT_CONTROLLER_JUST_CONNECTED));
}

void SetButton(bool is_down, bool was_down, int n3ds_button_id) {
    if (was_down == is_down) {
        return;
    }
    if (is_down) {
        InputManager::ButtonHandler()->PressKey(n3ds_button_id);
    } else {
        InputManager::ButtonHandler()->ReleaseKey(n3ds_button_id);
    }
}

} // namespace

void Init(JNIEnv* env, jobject context) {
    if (g_initialized) {
        return;
    }
    if (Paddleboat_init(env, context) != PADDLEBOAT_NO_ERROR) {
        return;
    }
    Paddleboat_setControllerStatusCallback(OnControllerStatusChanged, nullptr);
    ResolveInputEventBridge();
    g_previous_buttons.fill(0);
    g_initialized = true;
}

void Shutdown(JNIEnv* env) {
    if (!g_initialized) {
        return;
    }
    Paddleboat_setControllerStatusCallback(nullptr, nullptr);
    Paddleboat_destroy(env);
    g_initialized = false;
}

/**
 * Paddleboat's stickY follows Android's raw AXIS_Y convention (positive is down), the same as
 * the manual-mapping path's raw input before Java_..._onGamePadMoveEvent negates it to match
 * what InputManager::AnalogFactory::MoveJoystick expects (positive is up). Negate here by
 * default to match that existing convention; invert_left_stick_y (from the user-facing "Invert
 * Left Stick Y Axis" setting) flips it back for controllers/users that want the raw sign.
 */
void Update(JNIEnv* env, bool invert_left_stick_y, bool read_physical_controllers) {
    if (!IsInputManagerReady()) {
        return;
    }

    uint32_t physical_buttons = 0;
    StickState physical_left_stick;
    StickState physical_right_stick;
    bool physical_left_stick_active = false;
    bool physical_right_stick_active = false;

    if (read_physical_controllers && g_initialized) {
        Paddleboat_update(env);
        for (int index = 0; index < kMaxControllers; ++index) {
            Paddleboat_Controller_Data data{};
            if (Paddleboat_getControllerData(index, &data) != PADDLEBOAT_NO_ERROR) {
                g_previous_buttons[index] = 0;
                continue;
            }

            g_previous_buttons[index] = data.buttonsDown;
            physical_buttons |= data.buttonsDown;

            if (data.leftStick.stickX != 0.f || data.leftStick.stickY != 0.f) {
                physical_left_stick = {data.leftStick.stickX,
                                       invert_left_stick_y ? data.leftStick.stickY
                                                            : -data.leftStick.stickY};
                physical_left_stick_active = true;
            }
            if (data.rightStick.stickX != 0.f || data.rightStick.stickY != 0.f) {
                physical_right_stick = {data.rightStick.stickX, data.rightStick.stickY};
                physical_right_stick_active = true;
            }
        }
    }

    for (const auto& mapping : kButtonMappings) {
        const bool physical_down = (physical_buttons & mapping.paddleboat_mask) != 0;
        const auto virtual_it = g_virtual_buttons.find(mapping.n3ds_button_id);
        const bool virtual_down = virtual_it != g_virtual_buttons.end() && virtual_it->second;
        const bool combined_down = physical_down || virtual_down;

        SetButton(combined_down, g_previous_combined_buttons[mapping.n3ds_button_id],
                  mapping.n3ds_button_id);
        g_previous_combined_buttons[mapping.n3ds_button_id] = combined_down;
    }

    /** Forwards a stick only when this frame has something to report, leaving InputManager's
     *  analog state untouched otherwise instead of stomping the manual mapping path's last
     *  write with a synthetic center position every frame. */
    const auto ForwardStick = [](int n3ds_analog_id, const StickState& physical_stick,
                                 bool physical_stick_active) {
        const auto virtual_it = g_virtual_sticks.find(n3ds_analog_id);
        const bool virtual_active = virtual_it != g_virtual_sticks.end() &&
                                    (virtual_it->second.x != 0.f || virtual_it->second.y != 0.f);
        if (virtual_active) {
            InputManager::AnalogHandler()->MoveJoystick(n3ds_analog_id, virtual_it->second.x,
                                                        virtual_it->second.y);
        } else if (physical_stick_active) {
            InputManager::AnalogHandler()->MoveJoystick(n3ds_analog_id, physical_stick.x,
                                                        physical_stick.y);
        }
    };

    ForwardStick(InputManager::N3DS_CIRCLEPAD, physical_left_stick, physical_left_stick_active);
    ForwardStick(InputManager::N3DS_STICK_C, physical_right_stick, physical_right_stick_active);
}

void SetVirtualButton(int n3ds_button_id, bool pressed) {
    g_virtual_buttons[n3ds_button_id] = pressed;
}

void SetVirtualStick(int n3ds_analog_id, float x, float y) {
    g_virtual_sticks[n3ds_analog_id] = {x, y};
}

bool ProcessKeyEvent(JNIEnv* env, jobject key_event) {
    if (!g_initialized || !g_key_event_from_java || !g_input_event_release) {
        return false;
    }
    const AInputEvent* input_event = g_key_event_from_java(env, key_event);
    if (!input_event) {
        return false;
    }
    const bool handled = Paddleboat_processInputEvent(input_event) != 0;
    g_input_event_release(input_event);
    return handled;
}

bool ProcessMotionEvent(JNIEnv* env, jobject motion_event) {
    if (!g_initialized || !g_motion_event_from_java || !g_input_event_release) {
        return false;
    }
    const AInputEvent* input_event = g_motion_event_from_java(env, motion_event);
    if (!input_event) {
        return false;
    }
    const bool handled = Paddleboat_processInputEvent(input_event) != 0;
    g_input_event_release(input_event);
    return handled;
}

} // namespace GameControllerManager
