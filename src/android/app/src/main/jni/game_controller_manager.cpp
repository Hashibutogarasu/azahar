// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include <array>
#include <cstdint>

#include <android/api-level.h>
#include <android/input.h>
#include <paddleboat.h>

#include "jni/game_controller_manager.h"
#include "jni/id_cache.h"
#include "jni/input_manager.h"

namespace GameControllerManager {

namespace {

constexpr int kMaxControllers = 8;
std::array<uint32_t, kMaxControllers> g_previous_buttons{};
bool g_initialized = false;

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

void SetButton(uint32_t current, uint32_t previous, uint32_t mask, int n3ds_button_id) {
    const bool was_down = (previous & mask) != 0;
    const bool is_down = (current & mask) != 0;
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

void Update(JNIEnv* env) {
    if (!g_initialized) {
        return;
    }
    Paddleboat_update(env);

    for (int index = 0; index < kMaxControllers; ++index) {
        Paddleboat_Controller_Data data{};
        if (Paddleboat_getControllerData(index, &data) != PADDLEBOAT_NO_ERROR) {
            g_previous_buttons[index] = 0;
            continue;
        }

        const uint32_t previous = g_previous_buttons[index];
        const uint32_t current = data.buttonsDown;

        SetButton(current, previous, PADDLEBOAT_BUTTON_A, InputManager::N3DS_BUTTON_A);
        SetButton(current, previous, PADDLEBOAT_BUTTON_B, InputManager::N3DS_BUTTON_B);
        SetButton(current, previous, PADDLEBOAT_BUTTON_X, InputManager::N3DS_BUTTON_X);
        SetButton(current, previous, PADDLEBOAT_BUTTON_Y, InputManager::N3DS_BUTTON_Y);
        SetButton(current, previous, PADDLEBOAT_BUTTON_START, InputManager::N3DS_BUTTON_START);
        SetButton(current, previous, PADDLEBOAT_BUTTON_SELECT, InputManager::N3DS_BUTTON_SELECT);
        SetButton(current, previous, PADDLEBOAT_BUTTON_L1, InputManager::N3DS_TRIGGER_L);
        SetButton(current, previous, PADDLEBOAT_BUTTON_R1, InputManager::N3DS_TRIGGER_R);
        SetButton(current, previous, PADDLEBOAT_BUTTON_L2, InputManager::N3DS_BUTTON_ZL);
        SetButton(current, previous, PADDLEBOAT_BUTTON_R2, InputManager::N3DS_BUTTON_ZR);
        SetButton(current, previous, PADDLEBOAT_BUTTON_DPAD_UP, InputManager::N3DS_DPAD_UP);
        SetButton(current, previous, PADDLEBOAT_BUTTON_DPAD_DOWN, InputManager::N3DS_DPAD_DOWN);
        SetButton(current, previous, PADDLEBOAT_BUTTON_DPAD_LEFT, InputManager::N3DS_DPAD_LEFT);
        SetButton(current, previous, PADDLEBOAT_BUTTON_DPAD_RIGHT, InputManager::N3DS_DPAD_RIGHT);

        g_previous_buttons[index] = current;

        InputManager::AnalogHandler()->MoveJoystick(InputManager::N3DS_CIRCLEPAD, data.leftStick.x,
                                                     data.leftStick.y);
        InputManager::AnalogHandler()->MoveJoystick(InputManager::N3DS_STICK_C, data.rightStick.x,
                                                     data.rightStick.y);
    }
}

bool ProcessKeyEvent([[maybe_unused]] JNIEnv* env, [[maybe_unused]] jobject key_event) {
    if (!g_initialized || android_get_device_api_level() < 31) {
        return false;
    }
    AInputEvent* input_event = AKeyEvent_fromJava(env, key_event);
    if (!input_event) {
        return false;
    }
    const bool handled = Paddleboat_processInputEvent(input_event) != 0;
    AInputEvent_release(input_event);
    return handled;
}

bool ProcessMotionEvent([[maybe_unused]] JNIEnv* env, [[maybe_unused]] jobject motion_event) {
    if (!g_initialized || android_get_device_api_level() < 31) {
        return false;
    }
    AInputEvent* input_event = AMotionEvent_fromJava(env, motion_event);
    if (!input_event) {
        return false;
    }
    const bool handled = Paddleboat_processInputEvent(input_event) != 0;
    AInputEvent_release(input_event);
    return handled;
}

} // namespace GameControllerManager
