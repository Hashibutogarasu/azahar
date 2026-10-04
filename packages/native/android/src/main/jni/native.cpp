// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include <algorithm>
#include <array>
#include <atomic>
#include <charconv>
#include <chrono>
#include <codecvt>
#include <cstdio>
#include <cstring>
#include <exception>
#include <mutex>
#include <optional>
#include <string>
#include <thread>
#include <vector>
#include <dlfcn.h>

#include <android/api-level.h>
#include <android/log.h>
#include <android/native_window_jni.h>
#include <core/hw/aes/key.h>
#include <core/loader/smdh.h>
#include <core/system_titles.h>

#include <core/hle/service/cfg/cfg.h>
#include "audio_core/dsp_interface.h"
#include "audio_core/external_sink.h"
#include "audio_core/sink_details.h"
#include "azahar_session.h"
#include "common/arch.h"
#if CITRA_ARCH(arm64)
#include "common/aarch64/cpu_detect.h"
#elif CITRA_ARCH(x86_64)
#include "common/x64/cpu_detect.h"
#endif
#include "common/common_paths.h"
#include "common/dynamic_library/dynamic_library.h"
#include "common/file_util.h"
#include "common/logging/backend.h"
#include "common/logging/log.h"
#include "common/microprofile.h"
#include "common/scm_rev.h"
#include "common/scope_exit.h"
#include "common/settings.h"
#include "common/storage.h"
#include "common/string_util.h"
#include "core/core.h"
#include "core/frontend/applets/default_applets.h"
#include "core/frontend/camera/factory.h"
#include "core/hle/kernel/kernel.h"
#include "core/hle/service/ac/ac.h"
#include "core/hle/service/am/am.h"
#include "core/hle/service/nfc/nfc.h"
#include "core/hw/unique_data.h"
#include "core/loader/loader.h"
#include "core/memory.h"
#include "core/savestate.h"
#include "core/system_titles.h"
#include "jni/android_common/android_common.h"
#include "jni/applets/mii_selector.h"
#include "jni/applets/swkbd.h"
#include "jni/camera/ndk_camera.h"
#include "jni/camera/still_image_camera.h"
#include "jni/config.h"
#ifdef ENABLE_OPENGL
#include "jni/emu_window/emu_window_gl.h"
#endif
#ifdef ENABLE_VULKAN
#include "jni/emu_window/emu_window_vk.h"
#endif
#include "jni/id_cache.h"
#include "input_common/flutter_motion.h"
#include "jni/input_manager.h"
#include "jni/ndk_motion.h"
#include "jni/util.h"
#include "video_core/debug_utils/debug_utils.h"
#include "video_core/gpu.h"
#include "video_core/renderer_base.h"

#if defined(ENABLE_VULKAN) && CITRA_ARCH(arm64)
#include <adrenotools/driver.h>
#endif

namespace {

ANativeWindow* s_surf;
ANativeWindow* s_surf_secondary;

std::shared_ptr<Common::DynamicLibrary> vulkan_library{};
std::unique_ptr<EmuWindow_Android> window;
std::unique_ptr<EmuWindow_Android> secondary_window;

std::atomic<bool> stop_run{true};
std::atomic<bool> pause_emulation{false};
std::atomic<bool> advance_frame_requested{false};

std::mutex paused_mutex;
std::mutex running_mutex;
std::condition_variable running_cv;

/// Held while the emulation thread creates the windows and loads the system, and while it shuts
/// the system down, so that the methods the application calls from its own threads never reach a
/// renderer or a system that is half built or half torn down.
std::mutex core_lifecycle_mutex;

/// The initialization the application did on this library, kept so it can be replayed on the
/// library a session loads for itself.
struct HostState {
    std::mutex mutex;
    bool gpu_driver_initialized{};
    std::string hook_lib_dir;
    std::string custom_driver_dir;
    std::string custom_driver_name;
    std::string file_redirect_dir;
};

HostState g_host_state;

} // Anonymous namespace

/// The 3DS touchscreen is always the bottom screen, so touch input always targets
/// secondary_window when it exists (dual-surface mode), falling back to the single window
/// otherwise. Which Composable the app displays the bottom screen in is irrelevant here.
static EmuWindow_Android* GetTouchscreenWindow() {
    return secondary_window ? secondary_window.get() : window.get();
}

static jobject ToJavaCoreError(Core::System::ResultStatus result) {
    static const std::map<Core::System::ResultStatus, const char*> CoreErrorNameMap{
        {Core::System::ResultStatus::ErrorSystemFiles, "ErrorSystemFiles"},
        {Core::System::ResultStatus::ErrorSavestate, "ErrorSavestate"},
        {Core::System::ResultStatus::ErrorArticDisconnected, "ErrorArticDisconnected"},
        {Core::System::ResultStatus::ErrorUnknown, "ErrorUnknown"},
    };

    const auto name = CoreErrorNameMap.count(result) ? CoreErrorNameMap.at(result) : "ErrorUnknown";

    JNIEnv* env = IDCache::GetEnvForThread();
    const jclass core_error_class = IDCache::GetCoreErrorClass();
    return env->GetStaticObjectField(
        core_error_class, env->GetStaticFieldID(core_error_class, name,
                                                "Lcom/karasu256/azahar_reloaded/lib/azahar_for_flutter/NativeLibrary$CoreError;"));
}

static bool HandleCoreError(Core::System::ResultStatus result, const std::string& details) {
    JNIEnv* env = IDCache::GetEnvForThread();
    return env->CallStaticBooleanMethod(IDCache::GetNativeLibraryClass(), IDCache::GetOnCoreError(),
                                        ToJavaCoreError(result),
                                        env->NewStringUTF(details.c_str())) != JNI_FALSE;
}

static std::mutex g_session_callbacks_mutex;
static std::optional<AzaharSessionCallbacks> g_session_callbacks;

/**
 * Hands the audio to the session when it takes the frames, and plays it through OpenAL otherwise.
 * Runs after the settings are loaded, since loading them resets the output type.
 */
static void ApplySessionAudioOutput() {
    std::lock_guard lock{g_session_callbacks_mutex};
    if (!g_session_callbacks) {
        return;
    }
    if (g_session_callbacks->on_audio) {
        Settings::values.output_type = AudioCore::SinkType::External;
        AudioCore::SetExternalAudioHandler(
            [callbacks = *g_session_callbacks](const s16* frames, std::size_t frame_count) {
                callbacks.on_audio(callbacks.user, frames, frame_count);
            });
    } else {
        Settings::values.output_type = AudioCore::SinkType::OpenAL;
        AudioCore::SetExternalAudioHandler({});
    }
}

static int32_t ToSessionShaderStage(VideoCore::LoadCallbackStage stage) {
    switch (stage) {
    case VideoCore::LoadCallbackStage::Prepare:
    case VideoCore::LoadCallbackStage::Preload:
        return AZAHAR_SHADER_STAGE_PREPARE;
    case VideoCore::LoadCallbackStage::Decompile:
        return AZAHAR_SHADER_STAGE_DECOMPILE;
    case VideoCore::LoadCallbackStage::Build:
        return AZAHAR_SHADER_STAGE_BUILD;
    case VideoCore::LoadCallbackStage::Complete:
        return AZAHAR_SHADER_STAGE_COMPLETE;
    }
    return AZAHAR_SHADER_STAGE_PREPARE;
}

static void LoadDiskCacheProgress(VideoCore::LoadCallbackStage stage, int progress, int max) {
    {
        std::lock_guard lock{g_session_callbacks_mutex};
        if (g_session_callbacks) {
            if (g_session_callbacks->on_shader_progress) {
                g_session_callbacks->on_shader_progress(
                    g_session_callbacks->user, ToSessionShaderStage(stage),
                    static_cast<uint64_t>(progress), static_cast<uint64_t>(max));
            }
            return;
        }
    }
    JNIEnv* env = IDCache::GetEnvForThread();
    env->CallStaticVoidMethod(IDCache::GetDiskCacheProgressClass(),
                              IDCache::GetDiskCacheLoadProgress(),
                              IDCache::GetJavaLoadCallbackStage(stage), static_cast<jint>(progress),
                              static_cast<jint>(max));
}

static Camera::NDK::Factory* g_ndk_factory{};

static void TryShutdown() {
    std::lock_guard lifecycle{core_lifecycle_mutex};
    if (!window) {
        return;
    }

    window->DoneCurrent();
    if (secondary_window) {
        secondary_window->DoneCurrent();
    }
    Core::System::GetInstance().Shutdown();
    secondary_window.reset();
    window.reset();
    InputManager::Shutdown();
    MicroProfileShutdown();
}

static bool CheckMicPermission() {
    return IDCache::GetEnvForThread()->CallStaticBooleanMethod(IDCache::GetNativeLibraryClass(),
                                                               IDCache::GetRequestMicPermission());
}

/**
 * Parses an access point reported by NativeLibrary.scanWifiAccessPoints.
 * The expected format is "bssid|rssi|channel|security|ssid", where the SSID comes last so that it
 * may contain the separator itself.
 */
static std::optional<Service::AC::HostApInfo> ParseHostWifiEntry(const std::string& text) {
    std::array<std::size_t, 4> separators{};
    std::size_t position = 0;
    for (auto& separator : separators) {
        position = text.find('|', position);
        if (position == std::string::npos) {
            return std::nullopt;
        }
        separator = position++;
    }

    Service::AC::HostApInfo info;
    unsigned int bssid[6]{};
    const std::string bssid_text = text.substr(0, separators[0]);
    if (std::sscanf(bssid_text.c_str(), "%2x:%2x:%2x:%2x:%2x:%2x", &bssid[0], &bssid[1], &bssid[2],
                    &bssid[3], &bssid[4], &bssid[5]) != 6) {
        return std::nullopt;
    }
    for (std::size_t i = 0; i < info.bssid.size(); ++i) {
        info.bssid[i] = static_cast<u8>(bssid[i]);
    }

    std::array<int, 3> numbers{};
    for (std::size_t i = 0; i < numbers.size(); ++i) {
        const char* begin = text.data() + separators[i] + 1;
        const char* end = text.data() + separators[i + 1];
        if (std::from_chars(begin, end, numbers[i]).ec != std::errc{}) {
            return std::nullopt;
        }
    }
    info.rssi = static_cast<s16>(numbers[0]);
    info.channel = static_cast<u8>(std::clamp(numbers[1], 0, 255));
    info.security = static_cast<Service::AC::ApSecurity>(std::clamp(numbers[2], 0, 2));
    info.ssid = text.substr(separators[3] + 1);
    return info;
}

/**
 * Scans the wireless networks around the device.
 * The location permission is requested once per process, later calls only read the scan results.
 * @return The access points seen by the device, nothing when the scan is unavailable.
 */
static std::optional<std::vector<Service::AC::HostApInfo>> ScanHostWifiNetworks() {
    JNIEnv* env = IDCache::GetEnvForThread();
    static std::atomic<bool> permission_requested{false};
    if (!permission_requested.exchange(true)) {
        env->CallStaticBooleanMethod(IDCache::GetNativeLibraryClass(),
                                     IDCache::GetRequestWifiPermission());
    }

    auto* entries = static_cast<jobjectArray>(env->CallStaticObjectMethod(
        IDCache::GetNativeLibraryClass(), IDCache::GetScanWifiAccessPoints()));
    if (env->ExceptionCheck()) {
        env->ExceptionClear();
        return std::nullopt;
    }
    if (entries == nullptr) {
        return std::nullopt;
    }

    std::vector<Service::AC::HostApInfo> access_points;

    const jsize count = env->GetArrayLength(entries);
    for (jsize i = 0; i < count; ++i) {
        auto* entry = static_cast<jstring>(env->GetObjectArrayElement(entries, i));
        const std::string text = GetJString(env, entry);
        env->DeleteLocalRef(entry);
        if (auto info = ParseHostWifiEntry(text)) {
            access_points.push_back(std::move(*info));
        }
    }
    env->DeleteLocalRef(entries);
    return access_points;
}

/**
 * Loads [filepath] and runs it on the calling thread until it is stopped.
 *
 * @param reset_stop clears an earlier stop request once the previous emulation has ended. A
 * session clears it when it starts instead, so a stop it requests while loading is kept.
 */
static Core::System::ResultStatus RunCitra(const std::string& filepath, bool reset_stop) {
    std::scoped_lock lock(running_mutex);
    if (reset_stop) {
        stop_run = false;
        pause_emulation = false;
    }

    LOG_INFO(Frontend, "Azahar starting...");

    MicroProfileOnThreadCreate("EmuThread");

    if (filepath.empty()) {
        LOG_CRITICAL(Frontend, "Failed to load ROM: No ROM specified");
        return Core::System::ResultStatus::ErrorLoader;
    }

    Core::System& system{Core::System::GetInstance()};

    std::unique_lock lifecycle{core_lifecycle_mutex};
    Config{};
    ApplySessionAudioOutput();

    const auto graphics_api = Settings::values.graphics_api.GetValue();
    switch (graphics_api) {
#ifdef ENABLE_OPENGL
    case Settings::GraphicsAPI::OpenGL:
        window = std::make_unique<EmuWindow_Android_OpenGL>(system, s_surf);
        if (s_surf_secondary) {
            secondary_window = std::make_unique<EmuWindow_Android_OpenGL>(
                system, s_surf_secondary, true,
                static_cast<EmuWindow_Android_OpenGL*>(window.get())->GetShareContext());
        }
        break;
#endif
#ifdef ENABLE_VULKAN
    case Settings::GraphicsAPI::Vulkan:
        window = std::make_unique<EmuWindow_Android_Vulkan>(s_surf, vulkan_library);
        if (s_surf_secondary) {
            secondary_window = std::make_unique<EmuWindow_Android_Vulkan>(
                s_surf_secondary, vulkan_library, true);
        }
        break;
#endif
    default:
        LOG_CRITICAL(Frontend,
                     "Unknown or unsupported graphics API {}, falling back to available default",
                     graphics_api);
#ifdef ENABLE_OPENGL
        window = std::make_unique<EmuWindow_Android_OpenGL>(system, s_surf);
        if (s_surf_secondary) {
            secondary_window = std::make_unique<EmuWindow_Android_OpenGL>(
                system, s_surf_secondary, true,
                static_cast<EmuWindow_Android_OpenGL*>(window.get())->GetShareContext());
        }
#elif ENABLE_VULKAN
        window = std::make_unique<EmuWindow_Android_Vulkan>(s_surf, vulkan_library);
        if (s_surf_secondary) {
            secondary_window = std::make_unique<EmuWindow_Android_Vulkan>(
                s_surf_secondary, vulkan_library, true);
        }
#else
// TODO: Add a null renderer backend for this, perhaps.
#error "At least one renderer must be enabled."
#endif
        break;
    }

    // Replace with game-specific settings
    u64 program_id{};
    FileUtil::SetCurrentRomPath(filepath);
    auto app_loader = Loader::GetLoader(filepath);
    if (app_loader) {
        app_loader->ReadProgramId(program_id);
        system.RegisterAppLoaderEarly(app_loader);
    }
    system.ApplySettings();
    Settings::LogSettings();

    Camera::RegisterFactory("image", std::make_unique<Camera::StillImage::Factory>());

    auto ndk_factory = std::make_unique<Camera::NDK::Factory>();
    g_ndk_factory = ndk_factory.get();
    Camera::RegisterFactory("ndk", std::move(ndk_factory));

    // Register frontend applets
    Frontend::RegisterDefaultApplets(system);
    system.RegisterMiiSelector(std::make_shared<MiiSelector::AndroidMiiSelector>());
    system.RegisterSoftwareKeyboard(std::make_shared<SoftwareKeyboard::AndroidKeyboard>());

    // Register microphone permission check
    system.RegisterMicPermissionCheck(&CheckMicPermission);

    Service::AC::RegisterHostWifiScanner(&ScanHostWifiNetworks);

    Pica::g_debug_context = Pica::DebugContext::Construct();
    InputManager::Init();

    window->MakeCurrent();
    if (secondary_window) {
        secondary_window->MakeCurrent();
        window->MakeCurrent();
    }
    const Core::System::ResultStatus load_result{
        system.Load(*window, filepath, secondary_window.get())};
    if (load_result != Core::System::ResultStatus::Success) {
        return load_result;
    }
    lifecycle.unlock();

    LoadDiskCacheProgress(VideoCore::LoadCallbackStage::Prepare, 0, 0);

    std::unique_ptr<Frontend::GraphicsContext> cpu_context;
    system.GPU().Renderer().Rasterizer()->LoadDiskResources(stop_run, &LoadDiskCacheProgress);

    LoadDiskCacheProgress(VideoCore::LoadCallbackStage::Complete, 0, 0);

    SCOPE_EXIT({ TryShutdown(); });

    // Start running emulation
    while (!stop_run) {
        if (!pause_emulation) {
            const auto result = system.RunLoop();
            if (result == Core::System::ResultStatus::Success) {
                continue;
            }
            if (result == Core::System::ResultStatus::ShutdownRequested) {
                return result; // This also exits the emulation activity
            } else {
                auto* handler = InputManager::NDKMotionHandler();
                if (handler) {
                    handler->DisableSensors();
                }
                if (!HandleCoreError(result, system.GetStatusDetails())) {
                    // Frontend requests us to abort
                    // If the error was an Artic disconnect, return shutdown request.
                    if (result == Core::System::ResultStatus::ErrorArticDisconnected) {
                        return Core::System::ResultStatus::ShutdownRequested;
                    }
                    return result;
                }
                handler = InputManager::NDKMotionHandler();
                if (handler) {
                    handler->EnableSensors();
                }
            }
        } else {
            // Ensure no audio bleeds out while game is paused
            const float volume = Settings::values.volume.GetValue();
            SCOPE_EXIT({ Settings::values.volume = volume; });
            Settings::values.volume = 0;

            std::unique_lock pause_lock{paused_mutex};
            running_cv.wait(pause_lock, [] {
                return !pause_emulation || stop_run || advance_frame_requested;
            });
            if (advance_frame_requested && pause_emulation && !stop_run) {
                pause_lock.unlock();
                static_cast<void>(system.RunLoop());
                advance_frame_requested = false;
            } else {
                window->PollEvents();
            }
        }
    }

    return Core::System::ResultStatus::Success;
}

void InitializeGpuDriver(const std::string& hook_lib_dir, const std::string& custom_driver_dir,
                         const std::string& custom_driver_name,
                         const std::string& file_redirect_dir) {
#if defined(ENABLE_VULKAN) && CITRA_ARCH(arm64)
    void* handle{};
    const char* file_redirect_dir_{};
    int featureFlags{};

    // Enable driver file redirection when renderer debugging is enabled.
    if (Settings::values.renderer_debug && file_redirect_dir.size()) {
        featureFlags |= ADRENOTOOLS_DRIVER_FILE_REDIRECT;
        file_redirect_dir_ = file_redirect_dir.c_str();
    }

    // Try to load a custom driver.
    if (custom_driver_name.size()) {
        handle = adrenotools_open_libvulkan(
            RTLD_NOW, featureFlags | ADRENOTOOLS_DRIVER_CUSTOM, nullptr, hook_lib_dir.c_str(),
            custom_driver_dir.c_str(), custom_driver_name.c_str(), file_redirect_dir_, nullptr);
    }

    // Try to load the system driver.
    if (!handle) {
        handle = adrenotools_open_libvulkan(RTLD_NOW, featureFlags, nullptr, hook_lib_dir.c_str(),
                                            nullptr, nullptr, file_redirect_dir_, nullptr);
    }

    vulkan_library = std::make_shared<Common::DynamicLibrary>(handle);
#endif
}

extern "C" {

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_surfaceChanged(JNIEnv* env,
                                                            [[maybe_unused]] jobject obj,
                                                            jobject surf) {
    std::lock_guard lifecycle{core_lifecycle_mutex};
    s_surf = ANativeWindow_fromSurface(env, surf);

    bool notify = false;
    if (window) {
        notify = window->OnSurfaceChanged(s_surf);
    }

    auto& system = Core::System::GetInstance();
    if (notify && system.IsPoweredOn()) {
        system.GPU().Renderer().NotifySurfaceChanged();
    }

    LOG_INFO(Frontend, "Surface changed");
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_surfaceDestroyed([[maybe_unused]] JNIEnv* env,
                                                              [[maybe_unused]] jobject obj) {
    std::lock_guard lifecycle{core_lifecycle_mutex};
    if (s_surf != nullptr) {
        ANativeWindow_release(s_surf);
        s_surf = nullptr;
        if (window) {
            window->OnSurfaceChanged(s_surf);
        }
    }
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_surfaceChangedSecondary(
    JNIEnv* env, [[maybe_unused]] jobject obj, jobject surf) {
    std::lock_guard lifecycle{core_lifecycle_mutex};
    s_surf_secondary = ANativeWindow_fromSurface(env, surf);

    bool notify = false;
    if (secondary_window) {
        notify = secondary_window->OnSurfaceChanged(s_surf_secondary);
    }

    auto& system = Core::System::GetInstance();
    if (notify && system.IsPoweredOn()) {
        system.GPU().Renderer().NotifySurfaceChanged(true);
    }

    LOG_INFO(Frontend, "Secondary surface changed");
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_surfaceDestroyedSecondary(
    [[maybe_unused]] JNIEnv* env, [[maybe_unused]] jobject obj) {
    std::lock_guard lifecycle{core_lifecycle_mutex};
    if (s_surf_secondary != nullptr) {
        ANativeWindow_release(s_surf_secondary);
        s_surf_secondary = nullptr;
        if (secondary_window) {
            secondary_window->OnSurfaceChanged(s_surf_secondary);
        }
    }
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_doFrame([[maybe_unused]] JNIEnv* env,
                                                     [[maybe_unused]] jobject obj) {
    if (stop_run || pause_emulation) {
        return;
    }
    std::unique_lock lifecycle{core_lifecycle_mutex, std::try_to_lock};
    if (lifecycle.owns_lock() && window) {
        window->TryPresenting();
    }
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_doFrameSecondary([[maybe_unused]] JNIEnv* env,
                                                               [[maybe_unused]] jobject obj) {
    if (stop_run || pause_emulation) {
        return;
    }
    std::unique_lock lifecycle{core_lifecycle_mutex, std::try_to_lock};
    if (lifecycle.owns_lock() && secondary_window) {
        secondary_window->TryPresenting();
    }
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_setGyroSensitivity(
    [[maybe_unused]] JNIEnv* env, [[maybe_unused]] jobject obj, jfloat vertical_scale,
    jfloat horizontal_scale) {
    InputManager::SetGyroSensitivity(vertical_scale, horizontal_scale);
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_setGyroInvert(
    [[maybe_unused]] JNIEnv* env, [[maybe_unused]] jobject obj, jboolean invert_vertical,
    jboolean invert_horizontal) {
    InputManager::SetGyroInvert(invert_vertical == JNI_TRUE, invert_horizontal == JNI_TRUE);
}

void JNICALL Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_initializeGpuDriver(
    JNIEnv* env, jobject obj, jstring hook_lib_dir, jstring custom_driver_dir,
    jstring custom_driver_name, jstring file_redirect_dir) {
    std::string hook = GetJString(env, hook_lib_dir);
    std::string custom_dir = GetJString(env, custom_driver_dir);
    std::string custom_name = GetJString(env, custom_driver_name);
    std::string redirect_dir = GetJString(env, file_redirect_dir);
    {
        std::lock_guard lock{g_host_state.mutex};
        g_host_state.gpu_driver_initialized = true;
        g_host_state.hook_lib_dir = hook;
        g_host_state.custom_driver_dir = custom_dir;
        g_host_state.custom_driver_name = custom_name;
        g_host_state.file_redirect_dir = redirect_dir;
    }
    InitializeGpuDriver(hook, custom_dir, custom_name, redirect_dir);
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_notifyOrientationChange([[maybe_unused]] JNIEnv* env,
                                                                     [[maybe_unused]] jobject obj,
                                                                     jint layout_option,
                                                                     jint rotation,
                                                                     jboolean portrait) {
    Settings::values.layout_option = static_cast<Settings::LayoutOption>(layout_option);
}
void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_updateFramebuffer([[maybe_unused]] JNIEnv* env,
                                                               [[maybe_unused]] jobject obj,
                                                               jboolean is_portrait_mode) {
    std::lock_guard lifecycle{core_lifecycle_mutex};
    auto& system = Core::System::GetInstance();
    if (system.IsPoweredOn()) {
        system.GPU().Renderer().UpdateCurrentFramebufferLayout(is_portrait_mode);
    }
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_swapScreens([[maybe_unused]] JNIEnv* env,
                                                         [[maybe_unused]] jobject obj,
                                                         jboolean swap_screens, jint rotation) {
    std::lock_guard lifecycle{core_lifecycle_mutex};
    Settings::values.swap_screen = swap_screens;
    auto& system = Core::System::GetInstance();
    if (system.IsPoweredOn()) {
        system.GPU().Renderer().UpdateCurrentFramebufferLayout(IsPortraitMode());
    }
    InputManager::screen_rotation = rotation;
    Camera::NDK::g_rotation = rotation;
}

jboolean Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_areKeysAvailable([[maybe_unused]] JNIEnv* env,
                                                                  [[maybe_unused]] jobject obj) {
    HW::AES::InitKeys();
    return HW::AES::IsKeyXAvailable(HW::AES::KeySlotID::NCCHSecure1) &&
           HW::AES::IsKeyXAvailable(HW::AES::KeySlotID::NCCHSecure2);
}

jstring Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_getHomeMenuPath(JNIEnv* env,
                                                                [[maybe_unused]] jobject obj,
                                                                jint region) {
    const std::string path = Core::GetHomeMenuNcchPath(region);
    if (FileUtil::Exists(path)) {
        return ToJString(env, path);
    }
    return ToJString(env, "");
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_setStorageRoot(
    JNIEnv* env, [[maybe_unused]] jobject obj, jstring j_location) {
    if (!Common::Storage::SetRoot(GetJString(env, j_location))) {
        LOG_ERROR(Frontend, "The user directory could not be set");
    }
    FileUtil::SetUserPath();
}

jobjectArray Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_getInstalledGamePaths(
    JNIEnv* env, [[maybe_unused]] jclass clazz, jobjectArray j_roots, jobjectArray j_paths) {
    std::vector<std::string> games;
    const FileUtil::DirectoryEntryCallable ScanDir =
        [&games, &ScanDir](u64*, const std::string& directory, const std::string& virtual_name) {
            std::string path = directory + virtual_name;
            if (FileUtil::IsDirectory(path)) {
                path += '/';
                FileUtil::ForeachDirectoryEntry(nullptr, path, ScanDir);
            } else {
                if (!FileUtil::Exists(path))
                    return false;
                auto loader = Loader::GetLoader(path);
                if (loader) {
                    bool executable{};
                    const Loader::ResultStatus result = loader->IsExecutable(executable);
                    if (Loader::ResultStatus::Success == result && executable) {
                        games.emplace_back(path);
                    }
                }
            }
            return true;
        };

    const jsize entry_count = env->GetArrayLength(j_roots);
    for (jsize i = 0; i < entry_count; ++i) {
        auto* j_root = static_cast<jstring>(env->GetObjectArrayElement(j_roots, i));
        auto* j_path = static_cast<jstring>(env->GetObjectArrayElement(j_paths, i));
        const std::string root = GetJString(env, j_root);
        const std::string path = GetJString(env, j_path);
        env->DeleteLocalRef(j_root);
        env->DeleteLocalRef(j_path);

        const FileUtil::UserPath user_path =
            root == "nand" ? FileUtil::UserPath::NANDDir : FileUtil::UserPath::SDMCDir;
        ScanDir(nullptr, "", FileUtil::GetUserPath(user_path) + path);
    }

    jobjectArray jgames = env->NewObjectArray(static_cast<jsize>(games.size()),
                                              env->FindClass("java/lang/String"), nullptr);
    for (jsize i = 0; i < games.size(); ++i)
        env->SetObjectArrayElement(jgames, i, env->NewStringUTF(games[i].c_str()));
    return jgames;
}

jlongArray Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_getSystemTitleIds(JNIEnv* env,
                                                                     [[maybe_unused]] jobject obj,
                                                                     jint system_type,
                                                                     jint region) {
    const auto mode = static_cast<Core::SystemTitleSet>(system_type);
    const std::vector<u64> titles = Core::GetSystemTitleIds(mode, region);
    jlongArray jTitles = env->NewLongArray(titles.size());
    env->SetLongArrayRegion(jTitles, 0, titles.size(),
                            reinterpret_cast<const jlong*>(titles.data()));
    return jTitles;
}

jbooleanArray Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_areSystemTitlesInstalled(
    JNIEnv* env, [[maybe_unused]] jobject obj) {
    const auto installed = Core::AreSystemTitlesInstalled();
    jbooleanArray jInstalled = env->NewBooleanArray(2);
    jboolean* elements = env->GetBooleanArrayElements(jInstalled, nullptr);

    elements[0] = installed.first ? JNI_TRUE : JNI_FALSE;
    elements[1] = installed.second ? JNI_TRUE : JNI_FALSE;

    env->ReleaseBooleanArrayElements(jInstalled, elements, 0);

    return jInstalled;
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_uninstallSystemFiles(JNIEnv* env,
                                                                  [[maybe_unused]] jobject obj,
                                                                  jboolean old3ds) {
    Core::UninstallSystemFiles(old3ds ? Core::SystemTitleSet::Old3ds
                                      : Core::SystemTitleSet::New3ds);
}

[[maybe_unused]] static bool CheckKgslPresent() {
    constexpr auto KgslPath{"/dev/kgsl-3d0"};

    return access(KgslPath, F_OK) == 0;
}

[[maybe_unused]] bool SupportsCustomDriver() {
    return android_get_device_api_level() >= 28 && CheckKgslPresent();
}

jboolean JNICALL Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_utils_GpuDriverHelper_supportsCustomDriverLoading(
    JNIEnv* env, jobject instance) {
#ifdef CITRA_ARCH_arm64
    // If the KGSL device exists custom drivers can be loaded using adrenotools
    return SupportsCustomDriver();
#else
    return false;
#endif
}

// TODO(xperia64): ensure these cannot be called in an invalid state (e.g. after StopEmulation)
void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_unPauseEmulation([[maybe_unused]] JNIEnv* env,
                                                              [[maybe_unused]] jobject obj) {
    pause_emulation = false;
    Core::System::GetInstance().frame_limiter.SetFrameAdvancing(false);
    running_cv.notify_all();
    auto* handler = InputManager::NDKMotionHandler();
    if (handler) {
        handler->EnableSensors();
    }
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_pauseEmulation([[maybe_unused]] JNIEnv* env,
                                                            [[maybe_unused]] jobject obj) {
    pause_emulation = true;
    Core::System::GetInstance().frame_limiter.SetFrameAdvancing(true);
    auto* handler = InputManager::NDKMotionHandler();
    if (handler) {
        handler->DisableSensors();
    }
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_stopEmulation([[maybe_unused]] JNIEnv* env,
                                                           [[maybe_unused]] jobject obj) {
    stop_run = true;
    pause_emulation = false;
    advance_frame_requested = false;
    {
        std::lock_guard lifecycle{core_lifecycle_mutex};
        if (window) {
            window->StopPresenting();
        }
    }
    running_cv.notify_all();
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_advanceFrame([[maybe_unused]] JNIEnv* env,
                                                           [[maybe_unused]] jobject obj) {
    Core::System::GetInstance().frame_limiter.AdvanceFrame();
    advance_frame_requested = true;
    running_cv.notify_all();
}

jboolean Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_isRunning([[maybe_unused]] JNIEnv* env,
                                                           [[maybe_unused]] jobject obj) {
    return static_cast<jboolean>(!stop_run);
}

jlong Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_getRunningTitleId([[maybe_unused]] JNIEnv* env,
                                                                [[maybe_unused]] jobject obj) {
    u64 title_id{};
    Core::System::GetInstance().GetAppLoader().ReadProgramId(title_id);
    return static_cast<jlong>(title_id);
}

jboolean Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_onGamePadEvent([[maybe_unused]] JNIEnv* env,
                                                                [[maybe_unused]] jobject obj,
                                                                [[maybe_unused]] jstring j_device,
                                                                jint j_button, jint action) {
    bool consumed{};
    if (action) {
        consumed = InputManager::ButtonHandler()->PressKey(j_button);
    } else {
        consumed = InputManager::ButtonHandler()->ReleaseKey(j_button);
    }

    return static_cast<jboolean>(consumed);
}

jboolean Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_onGamePadMoveEvent(
    [[maybe_unused]] JNIEnv* env, [[maybe_unused]] jobject obj, [[maybe_unused]] jstring j_device,
    jint axis, jfloat x, jfloat y) {
    // Clamp joystick movement to supported minimum and maximum
    // Citra uses an inverted y axis sent by the frontend
    x = std::clamp(x, -1.f, 1.f);
    y = std::clamp(-y, -1.f, 1.f);

    // Clamp the input to a circle (while touch input is already clamped in the frontend, gamepad is
    // unknown)
    float r = x * x + y * y;
    if (r > 1.0f) {
        r = std::sqrt(r);
        x /= r;
        y /= r;
    }
    return static_cast<jboolean>(InputManager::AnalogHandler()->MoveJoystick(axis, x, y));
}

jboolean Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_onGamePadAxisEvent(
    [[maybe_unused]] JNIEnv* env, [[maybe_unused]] jobject obj, [[maybe_unused]] jstring j_device,
    jint axis_id, jfloat axis_val) {
    return static_cast<jboolean>(
        InputManager::ButtonHandler()->AnalogButtonEvent(axis_id, axis_val));
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_setMotion([[maybe_unused]] JNIEnv* env,
                                                       [[maybe_unused]] jobject obj, jfloat accel_x,
                                                       jfloat accel_y, jfloat accel_z,
                                                       jfloat gyro_x, jfloat gyro_y, jfloat gyro_z) {
    InputCommon::FlutterMotion::Set(Common::Vec3<float>{accel_x, accel_y, accel_z},
                                    Common::Vec3<float>{gyro_x, gyro_y, gyro_z});
}

jboolean Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_onTouchEvent([[maybe_unused]] JNIEnv* env,
                                                              [[maybe_unused]] jobject obj,
                                                              jfloat x, jfloat y,
                                                              jboolean pressed) {
    return static_cast<jboolean>(GetTouchscreenWindow()->OnTouchEvent(
        static_cast<int>(x + 0.5), static_cast<int>(y + 0.5), pressed));
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_onTouchMoved([[maybe_unused]] JNIEnv* env,
                                                          [[maybe_unused]] jobject obj, jfloat x,
                                                          jfloat y) {
    GetTouchscreenWindow()->OnTouchMoved((int)x, (int)y);
}

jlong Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_getTitleId(JNIEnv* env, [[maybe_unused]] jobject obj,
                                                         jstring j_filename) {
    std::string filepath = GetJString(env, j_filename);
    const auto loader = Loader::GetLoader(filepath);

    u64 title_id{};
    if (loader) {
        loader->ReadProgramId(title_id);
    }
    return static_cast<jlong>(title_id);
}

jboolean Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_getIsSystemTitle(JNIEnv* env,
                                                                  [[maybe_unused]] jobject obj,
                                                                  jstring path) {
    const std::string filepath = GetJString(env, path);
    const auto loader = Loader::GetLoader(filepath);

    // Since we also read through invalid file extensions, we have to check if the loader is valid
    if (loader == nullptr) {
        return false;
    }

    u64 program_id = 0;
    loader->ReadProgramId(program_id);
    return ((program_id >> 32) & 0xFFFFFFFF) == 0x00040010;
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_createConfigFile([[maybe_unused]] JNIEnv* env,
                                                              [[maybe_unused]] jobject obj) {
    Config{};
}

static std::atomic<bool> console_log_enabled{true};
static std::atomic<bool> logging_started{false};

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_setConsoleLogEnabled([[maybe_unused]] JNIEnv* env,
                                                                  [[maybe_unused]] jobject obj,
                                                                  jboolean enabled) {
    console_log_enabled = enabled;
    if (logging_started) {
        Common::Log::SetColorConsoleBackendEnabled(enabled);
    }
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_startLogging(JNIEnv* env,
                                                          [[maybe_unused]] jobject obj) {
    const jclass native_library = IDCache::GetNativeLibraryClass();
    const jmethodID on_log_line = env->GetStaticMethodID(native_library, "onLogLine", "([B)V");
    const jmethodID flush_log = env->GetStaticMethodID(native_library, "flushLog", "()V");

    Common::Log::Initialize();
    Common::Log::SetSink(Common::Log::Sink{
        .write =
            [native_library, on_log_line](std::string_view line) {
                JNIEnv* thread_env = IDCache::GetEnvForThread();
                jbyteArray bytes = thread_env->NewByteArray(static_cast<jsize>(line.size()));
                thread_env->SetByteArrayRegion(bytes, 0, static_cast<jsize>(line.size()),
                                               reinterpret_cast<const jbyte*>(line.data()));
                thread_env->CallStaticVoidMethod(native_library, on_log_line, bytes);
                thread_env->DeleteLocalRef(bytes);
                if (thread_env->ExceptionCheck()) {
                    thread_env->ExceptionClear();
                }
            },
        .flush =
            [native_library, flush_log] {
                JNIEnv* thread_env = IDCache::GetEnvForThread();
                thread_env->CallStaticVoidMethod(native_library, flush_log);
                if (thread_env->ExceptionCheck()) {
                    thread_env->ExceptionClear();
                }
            },
    });
    Common::Log::SetColorConsoleBackendEnabled(console_log_enabled);
    logging_started = true;
    Common::Log::Start();
    LOG_INFO(Frontend, "Logging backend initialised");
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_logUserDirectory(JNIEnv* env,
                                                              [[maybe_unused]] jobject obj,
                                                              jstring j_path) {
    std::string_view path = env->GetStringUTFChars(j_path, 0);
    LOG_INFO(Frontend, "User directory path: {}", path);
    env->ReleaseStringUTFChars(j_path, path.data());
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_reloadSettings([[maybe_unused]] JNIEnv* env,
                                                            [[maybe_unused]] jobject obj) {
    std::lock_guard lifecycle{core_lifecycle_mutex};
    Config{};
    Core::System& system{Core::System::GetInstance()};

    // Replace with game-specific settings
    if (system.IsPoweredOn()) {
        u64 program_id{};
        system.GetAppLoader().ReadProgramId(program_id);
    }

    system.ApplySettings();
}

jdoubleArray Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_getPerfStats(JNIEnv* env,
                                                                  [[maybe_unused]] jobject obj) {
    auto& core = Core::System::GetInstance();
    jdoubleArray j_stats = env->NewDoubleArray(4);

    if (core.IsPoweredOn()) {
        auto results = core.GetAndResetPerfStats();

        // Converting the structure into an array makes it easier to pass it to the frontend
        double stats[4] = {results.system_fps, results.game_fps, results.frametime,
                           results.emulation_speed};

        env->SetDoubleArrayRegion(j_stats, 0, 4, stats);
    }

    return j_stats;
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_run__Ljava_lang_String_2(JNIEnv* env,
                                                                      [[maybe_unused]] jobject obj,
                                                                      jstring j_path) {
    const std::string path = GetJString(env, j_path);

    if (!stop_run) {
        stop_run = true;
        running_cv.notify_all();
    }

    const Core::System::ResultStatus result{RunCitra(path, true)};
    if (result != Core::System::ResultStatus::Success) {
        env->CallStaticVoidMethod(IDCache::GetNativeLibraryClass(),
                                  IDCache::GetExitEmulationActivity(), static_cast<int>(result));
    }
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_reloadCameraDevices([[maybe_unused]] JNIEnv* env,
                                                                 [[maybe_unused]] jobject obj) {
    if (g_ndk_factory) {
        g_ndk_factory->ReloadCameraDevices();
    }
}

jboolean Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_loadAmiibo(JNIEnv* env,
                                                            [[maybe_unused]] jobject obj,
                                                            jstring j_file) {
    std::string filepath = GetJString(env, j_file);
    Core::System& system{Core::System::GetInstance()};
    Service::SM::ServiceManager& sm = system.ServiceManager();
    auto nfc = sm.GetService<Service::NFC::Module::Interface>("nfc:u");
    if (nfc == nullptr) {
        return static_cast<jboolean>(false);
    }

    return static_cast<jboolean>(nfc->LoadAmiibo(filepath));
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_removeAmiibo([[maybe_unused]] JNIEnv* env,
                                                          [[maybe_unused]] jobject obj) {
    Core::System& system{Core::System::GetInstance()};
    Service::SM::ServiceManager& sm = system.ServiceManager();
    auto nfc = sm.GetService<Service::NFC::Module::Interface>("nfc:u");
    if (nfc == nullptr) {
        return;
    }

    nfc->RemoveAmiibo();
}

JNIEXPORT jobject JNICALL Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_utils_CiaInstallWorker_installCIA(
    JNIEnv* env, jobject jobj, jstring jpath) {
    std::string path = GetJString(env, jpath);
    Service::AM::InstallStatus res = Service::AM::InstallCIA(
        path, [env, jobj](std::size_t total_bytes_read, std::size_t file_size) {
            env->CallVoidMethod(jobj, IDCache::GetCiaInstallHelperSetProgress(),
                                static_cast<jint>(file_size), static_cast<jint>(total_bytes_read));
        });

    return IDCache::GetJavaCiaInstallStatus(res);
}

jobjectArray Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_getSavestateInfo(
    JNIEnv* env, [[maybe_unused]] jobject obj) {
    const jclass date_class = env->FindClass("java/util/Date");
    const auto date_constructor = env->GetMethodID(date_class, "<init>", "(J)V");

    const jclass savestate_info_class = IDCache::GetSavestateInfoClass();
    const auto slot_field = env->GetFieldID(savestate_info_class, "slot", "I");
    const auto date_field = env->GetFieldID(savestate_info_class, "time", "Ljava/util/Date;");

    const Core::System& system{Core::System::GetInstance()};
    if (!system.IsPoweredOn()) {
        return nullptr;
    }

    u64 title_id;
    if (system.GetAppLoader().ReadProgramId(title_id) != Loader::ResultStatus::Success) {
        return nullptr;
    }

    const auto savestates = Core::ListSaveStates(title_id, system.Movie().GetCurrentMovieID());
    const jobjectArray array =
        env->NewObjectArray(static_cast<jsize>(savestates.size()), savestate_info_class, nullptr);
    for (std::size_t i = 0; i < savestates.size(); ++i) {
        const jobject object = env->AllocObject(savestate_info_class);
        env->SetIntField(object, slot_field, static_cast<jint>(savestates[i].slot));
        env->SetObjectField(object, date_field,
                            env->NewObject(date_class, date_constructor,
                                           static_cast<jlong>(savestates[i].time * 1000)));

        env->SetObjectArrayElement(array, i, object);
    }
    return array;
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_saveState([[maybe_unused]] JNIEnv* env,
                                                       [[maybe_unused]] jobject obj, jint slot) {
    Core::System::GetInstance().SendSignal(Core::System::Signal::Save, slot);
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_loadState([[maybe_unused]] JNIEnv* env,
                                                       [[maybe_unused]] jobject obj, jint slot) {
    Core::System::GetInstance().SendSignal(Core::System::Signal::Load, slot);
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_logDeviceInfo([[maybe_unused]] JNIEnv* env,
                                                           [[maybe_unused]] jobject obj) {
    LOG_INFO(Frontend, "Azahar Version: {} | {}-{}", Common::g_build_fullname, Common::g_scm_branch,
             Common::g_scm_desc);
    LOG_INFO(Frontend, "Host CPU: {}", Common::GetCPUCaps().cpu_string);
    // There is no decent way to get the OS version, so we log the API level instead.
    LOG_INFO(Frontend, "Host OS: Android API level {}", android_get_device_api_level());
}

jboolean Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_isFullConsoleLinked(JNIEnv* env, jobject obj) {
    return HW::UniqueData::IsFullConsoleLinked();
}

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_unlinkConsole(JNIEnv* env, jobject obj) {
    HW::UniqueData::UnlinkConsole();
}

} // extern "C"

/**
 * One emulation session driven through the C ABI declared in azahar_session.h.
 *
 * The session owns the emulation thread, the callbacks and the screen textures it asked the
 * application for. Destroying it stops the emulation, joins the thread and releases everything,
 * so another session can be created in the same process afterwards.
 */
struct AzaharSession {
    AzaharSessionCallbacks callbacks{};
    AzaharSessionOptions options{};
    std::string path;
    std::thread emulation_thread;
    AudioCore::SinkType previous_output_type{AudioCore::SinkType::Auto};
    bool previous_swap_screen{false};
};

namespace {

std::mutex g_active_session_mutex;
AzaharSession* g_active_session{};

std::size_t CurrentFcramSize() {
    return Settings::values.is_new_3ds.GetValue() ? Memory::FCRAM_N3DS_SIZE : Memory::FCRAM_SIZE;
}

void ReportSessionError(const AzaharSessionCallbacks& callbacks, const std::string& message) {
    LOG_CRITICAL(Frontend, "{}", message);
    if (callbacks.on_error) {
        callbacks.on_error(callbacks.user, message.c_str());
    }
}

/**
 * Asks the application for a screen texture and hands its surface to the emulation.
 *
 * The id of the texture is reported first, because the application shows the texture as soon as
 * it knows the id, and that is what makes Flutter hand out a surface. The renderer creates what
 * it draws into from that surface, so this waits until Flutter has made one available.
 *
 * @return false when the texture could not be created or no surface became available in time.
 */
bool CreateSessionTexture(const AzaharSession& session, int width, int height, bool secondary) {
    JNIEnv* env = IDCache::GetEnvForThread();
    const jlong texture_id = env->CallStaticLongMethod(
        IDCache::GetNativeLibraryClass(), IDCache::GetCreateSessionTexture(),
        static_cast<jint>(width), static_cast<jint>(height), static_cast<jboolean>(secondary));
    if (env->ExceptionCheck()) {
        env->ExceptionClear();
        return false;
    }
    if (texture_id < 0) {
        return false;
    }

    if (session.callbacks.on_texture) {
        session.callbacks.on_texture(session.callbacks.user, static_cast<int64_t>(texture_id),
                                     secondary ? 1 : 0);
    }

    constexpr auto surface_timeout = std::chrono::seconds(10);
    constexpr auto surface_poll_interval = std::chrono::milliseconds(20);
    const auto deadline = std::chrono::steady_clock::now() + surface_timeout;
    while (true) {
        const jobject surface = env->CallStaticObjectMethod(IDCache::GetNativeLibraryClass(),
                                                            IDCache::GetGetSessionSurface(),
                                                            static_cast<jboolean>(secondary));
        if (env->ExceptionCheck()) {
            env->ExceptionClear();
            return false;
        }
        if (surface != nullptr) {
            if (secondary) {
                Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_surfaceChangedSecondary(env, nullptr,
                                                                                surface);
            } else {
                Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_surfaceChanged(env, nullptr, surface);
            }
            env->DeleteLocalRef(surface);
            return true;
        }
        if (std::chrono::steady_clock::now() >= deadline) {
            return false;
        }
        std::this_thread::sleep_for(surface_poll_interval);
    }
}

void ReleaseSessionTextures() {
    JNIEnv* env = IDCache::GetEnvForThread();
    env->CallStaticVoidMethod(IDCache::GetNativeLibraryClass(),
                              IDCache::GetReleaseSessionTextures());
    if (env->ExceptionCheck()) {
        env->ExceptionClear();
    }
}

} // Anonymous namespace

extern "C" {

static AzaharSession* CreateSessionUnguarded(const char* game_path,
                                             const AzaharSessionOptions* options,
                                             const AzaharSessionCallbacks* callbacks) {
    if (game_path == nullptr || options == nullptr || callbacks == nullptr) {
        return nullptr;
    }
    std::lock_guard lock{g_active_session_mutex};
    if (g_active_session != nullptr) {
        return nullptr;
    }
    auto* session = new AzaharSession();
    session->callbacks = *callbacks;
    session->options = *options;
    session->path = game_path;
    session->previous_swap_screen = Settings::values.swap_screen.GetValue();
    g_active_session = session;
    return session;
}

static int32_t StartSessionUnguarded(AzaharSession* session) {
    if (session == nullptr) {
        return AZAHAR_STATUS_INVALID_ARGUMENT;
    }

    if (!CreateSessionTexture(*session, session->options.primary_width,
                              session->options.primary_height, false) ||
        s_surf == nullptr) {
        ReportSessionError(session->callbacks, "Failed to create the top screen texture");
        return AZAHAR_STATUS_LOAD_FAILED;
    }
    if (session->options.dual_screen != 0 &&
        (!CreateSessionTexture(*session, session->options.secondary_width,
                               session->options.secondary_height, true) ||
         s_surf_secondary == nullptr)) {
        ReportSessionError(session->callbacks, "Failed to create the bottom screen texture");
        return AZAHAR_STATUS_LOAD_FAILED;
    }

    {
        std::lock_guard lock{g_session_callbacks_mutex};
        g_session_callbacks = session->callbacks;
    }
    session->previous_output_type = Settings::values.output_type.GetValue();

    stop_run = false;
    pause_emulation = false;
    advance_frame_requested = false;
    session->emulation_thread = std::thread([session] {
        Core::System::ResultStatus result = Core::System::ResultStatus::ErrorUnknown;
        try {
            result = RunCitra(session->path, false);
        } catch (const std::exception& exception) {
            ReportSessionError(session->callbacks,
                               std::string{"The emulation threw: "} + exception.what());
        } catch (...) {
            ReportSessionError(session->callbacks, "The emulation threw an unknown exception");
        }
        stop_run = true;
        if (result == Core::System::ResultStatus::ShutdownRequested &&
            session->callbacks.on_shutdown_requested) {
            session->callbacks.on_shutdown_requested(session->callbacks.user);
        }
        if (result != Core::System::ResultStatus::Success &&
            result != Core::System::ResultStatus::ShutdownRequested) {
            ReportSessionError(session->callbacks,
                               "The emulation ended with status " +
                                   std::to_string(static_cast<int>(result)));
        }
    });
    return AZAHAR_STATUS_OK;
}

int32_t azahar_session_pause(AzaharSession* session) {
    if (session == nullptr) {
        return AZAHAR_STATUS_INVALID_ARGUMENT;
    }
    pause_emulation = true;
    Core::System::GetInstance().frame_limiter.SetFrameAdvancing(true);
    if (auto* handler = InputManager::NDKMotionHandler()) {
        handler->DisableSensors();
    }
    return AZAHAR_STATUS_OK;
}

int32_t azahar_session_resume(AzaharSession* session) {
    if (session == nullptr) {
        return AZAHAR_STATUS_INVALID_ARGUMENT;
    }
    pause_emulation = false;
    Core::System::GetInstance().frame_limiter.SetFrameAdvancing(false);
    running_cv.notify_all();
    if (auto* handler = InputManager::NDKMotionHandler()) {
        handler->EnableSensors();
    }
    return AZAHAR_STATUS_OK;
}

size_t azahar_session_fcram_size(const AzaharSession* session) {
    if (session == nullptr || stop_run || !Core::System::GetInstance().IsPoweredOn()) {
        return 0;
    }
    return CurrentFcramSize();
}

int32_t azahar_session_read_memory(AzaharSession* session, uint32_t address, uint8_t* out,
                                   size_t len) {
    if (session == nullptr || out == nullptr) {
        return AZAHAR_STATUS_INVALID_ARGUMENT;
    }
    Core::System& system = Core::System::GetInstance();
    if (len == 0 || stop_run || !system.IsPoweredOn()) {
        return AZAHAR_STATUS_INVALID_ADDRESS;
    }
    const auto process = system.Kernel().GetCurrentProcess();
    if (!process) {
        return AZAHAR_STATUS_INVALID_ADDRESS;
    }
    constexpr uint64_t page_size = 0x1000;
    const uint64_t end = static_cast<uint64_t>(address) + len;
    if (end > 0x100000000ULL) {
        return AZAHAR_STATUS_INVALID_ADDRESS;
    }
    Memory::MemorySystem& memory = system.Memory();
    for (uint64_t page = address & ~(page_size - 1); page < end; page += page_size) {
        if (!memory.IsValidVirtualAddress(*process, static_cast<VAddr>(page))) {
            return AZAHAR_STATUS_INVALID_ADDRESS;
        }
    }
    memory.ReadBlock(*process, address, out, len);
    return AZAHAR_STATUS_OK;
}

int32_t azahar_session_read_fcram(AzaharSession* session, size_t offset, uint8_t* out, size_t len) {
    if (session == nullptr || out == nullptr) {
        return AZAHAR_STATUS_INVALID_ARGUMENT;
    }
    Core::System& system = Core::System::GetInstance();
    if (stop_run || !system.IsPoweredOn()) {
        return AZAHAR_STATUS_INVALID_ADDRESS;
    }
    const std::size_t size = CurrentFcramSize();
    if (offset > size || len > size - offset) {
        return AZAHAR_STATUS_INVALID_ADDRESS;
    }
    std::memcpy(out, system.Memory().GetFCRAMPointer(0) + offset, len);
    return AZAHAR_STATUS_OK;
}

static void DestroySessionUnguarded(AzaharSession* session) {
    if (session == nullptr) {
        return;
    }

    stop_run = true;
    pause_emulation = false;
    advance_frame_requested = false;
    {
        std::lock_guard lifecycle{core_lifecycle_mutex};
        if (window) {
            window->StopPresenting();
        }
    }
    running_cv.notify_all();
    if (session->emulation_thread.joinable()) {
        session->emulation_thread.join();
    }

    TryShutdown();
    AudioCore::SetExternalAudioHandler({});
    Settings::values.output_type = session->previous_output_type;
    Settings::values.swap_screen = session->previous_swap_screen;
    {
        std::lock_guard lock{g_session_callbacks_mutex};
        g_session_callbacks.reset();
    }
    JNIEnv* env = IDCache::GetEnvForThread();
    Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_surfaceDestroyed(env, nullptr);
    Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_surfaceDestroyedSecondary(env, nullptr);
    ReleaseSessionTextures();

    {
        std::lock_guard lock{g_active_session_mutex};
        g_active_session = nullptr;
    }
    delete session;
}

} // extern "C"

namespace {

/// The JNI methods of `NativeLibrary` that act on a running emulation. While a session runs in
/// a library of its own, these are bound to that library instead of the one `System.loadLibrary`
/// loaded.
struct SessionNative {
    const char* name;
    const char* signature;
};

constexpr SessionNative kSessionNatives[] = {
    {"onGamePadEvent", "(Ljava/lang/String;II)Z"},
    {"onGamePadMoveEvent", "(Ljava/lang/String;IFF)Z"},
    {"onGamePadAxisEvent", "(Ljava/lang/String;IF)Z"},
    {"setVirtualButton", "(IZ)V"},
    {"setVirtualStick", "(IFF)V"},
    {"clearVirtualControllerInputs", "()V"},
    {"setGyroPreferExternalController", "(Z)V"},
    {"setGyroSensitivity", "(FF)V"},
    {"setGyroInvert", "(ZZ)V"},
    {"setMotion", "(FFFFFF)V"},
    {"onTouchEvent", "(FFZ)Z"},
    {"onTouchMoved", "(FF)V"},
    {"reloadSettings", "()V"},
    {"surfaceChanged", "(Landroid/view/Surface;)V"},
    {"surfaceDestroyed", "()V"},
    {"doFrame", "()V"},
    {"surfaceChangedSecondary", "(Landroid/view/Surface;)V"},
    {"surfaceDestroyedSecondary", "()V"},
    {"doFrameSecondary", "()V"},
    {"initGameControllerManager", "(Landroid/content/Context;)V"},
    {"shutdownGameControllerManager", "()V"},
    {"updateGameControllers", "(ZZ)V"},
    {"onGameControllerKeyEvent", "(Landroid/view/KeyEvent;)Z"},
    {"onGameControllerMotionEvent", "(Landroid/view/MotionEvent;)Z"},
    {"unPauseEmulation", "()V"},
    {"pauseEmulation", "()V"},
    {"stopEmulation", "()V"},
    {"advanceFrame", "()V"},
    {"dumpCurrentMemory", "()[B"},
    {"startMemoryRecording", "(Ljava/lang/String;I)V"},
    {"stopMemoryRecording", "()I"},
    {"isRunning", "()Z"},
    {"getRunningTitleId", "()J"},
    {"getPerfStats", "()[D"},
    {"updateFramebuffer", "(Z)V"},
    {"swapScreens", "(ZI)V"},
    {"notifyOrientationChange", "(IIZ)V"},
    {"reloadCameraDevices", "()V"},
    {"loadAmiibo", "(Ljava/lang/String;)Z"},
    {"removeAmiibo", "()V"},
    {"getSavestateInfo", "()[Lcom/karasu256/azahar_reloaded/lib/azahar_for_flutter/NativeLibrary$SaveStateInfo;"},
    {"saveState", "(I)V"},
    {"loadState", "(I)V"},
};

} // Anonymous namespace

extern "C" {

/**
 * Describes the initialization the application did on the library that `System.loadLibrary`
 * loaded, in a form the library of a session can replay.
 */
struct AzaharHostState {
    int32_t logging_started;
    int32_t console_log_enabled;
    int32_t gpu_driver_initialized;
    const char* hook_lib_dir;
    const char* custom_driver_dir;
    const char* custom_driver_name;
    const char* file_redirect_dir;
    const AzaharStorageApi* storage;
};

static jobject g_application_context{};

void Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_setApplicationContext([[maybe_unused]] JNIEnv* env,
                                                                   [[maybe_unused]] jobject obj,
                                                                   jobject context) {
    if (g_application_context != nullptr) {
        env->DeleteGlobalRef(g_application_context);
    }
    g_application_context = env->NewGlobalRef(context);
}

void* azahar_host_java_vm() {
    return IDCache::GetJavaVM();
}

void* azahar_host_application_context() {
    return g_application_context;
}

void* azahar_host_class_loader() {
    return IDCache::GetAppClassLoader();
}

const AzaharHostState* azahar_host_state() {
    static AzaharHostState state;
    std::lock_guard lock{g_host_state.mutex};
    state.logging_started = logging_started ? 1 : 0;
    state.console_log_enabled = console_log_enabled ? 1 : 0;
    state.gpu_driver_initialized = g_host_state.gpu_driver_initialized ? 1 : 0;
    state.hook_lib_dir = g_host_state.hook_lib_dir.c_str();
    state.custom_driver_dir = g_host_state.custom_driver_dir.c_str();
    state.custom_driver_name = g_host_state.custom_driver_name.c_str();
    state.file_redirect_dir = g_host_state.file_redirect_dir.c_str();
    state.storage = Common::Storage::Api();
    return &state;
}

/**
 * Binds the emulation methods of `NativeLibrary` to the library of a session.
 *
 * @param session_library the handle `dlopen` returned for that library.
 */
static void BindNativesUnguarded(void* session_library) {
    static constexpr std::string_view prefix = "Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_";
    JNIEnv* env = IDCache::GetEnvForThread();
    const jclass native_library = IDCache::GetNativeLibraryClass();
    for (const SessionNative& native : kSessionNatives) {
        const std::string symbol = std::string{prefix} + native.name;
        void* function = dlsym(session_library, symbol.c_str());
        if (function == nullptr) {
            LOG_WARNING(Frontend, "The session library has no {}", symbol);
            continue;
        }
        const JNINativeMethod method{const_cast<char*>(native.name),
                                     const_cast<char*>(native.signature), function};
        if (env->RegisterNatives(native_library, &method, 1) != JNI_OK) {
            env->ExceptionClear();
            LOG_WARNING(Frontend, "Failed to bind {}", symbol);
        }
    }
}

/**
 * Binds the methods of `NativeLibrary` back to the library `System.loadLibrary` loaded.
 */
void azahar_host_unbind_natives() {
    JNIEnv* env = IDCache::GetEnvForThread();
    env->UnregisterNatives(IDCache::GetNativeLibraryClass());
}

/**
 * Initializes a library that a session loaded with `dlopen`, for which `JNI_OnLoad` did not run.
 */
static std::string g_session_library_error;

/**
 * Why the last call of [azahar_session_lib_init] failed, or an empty string.
 */
const char* azahar_session_lib_last_error() {
    return g_session_library_error.c_str();
}

static int32_t InitSessionLibraryUnguarded(void* java_vm, void* app_class_loader,
                                           const AzaharHostState* host_state) {
    g_session_library_error.clear();
    const char* step = "the cache of Java classes";
    try {
        if (!IDCache::InitializeForSession(static_cast<JavaVM*>(java_vm),
                                           static_cast<jobject>(app_class_loader))) {
            g_session_library_error = "the cache of Java classes could not be initialized";
            return AZAHAR_STATUS_LOAD_FAILED;
        }
        JNIEnv* env = IDCache::GetEnvForThread();
        if (host_state != nullptr) {
            Common::Storage::Register(host_state->storage);
        }
        step = "the logging";
        if (host_state != nullptr) {
            console_log_enabled = host_state->console_log_enabled != 0;
        }
        if (host_state != nullptr && host_state->logging_started != 0) {
            Java_com_karasu256_azahar_1reloaded_lib_azahar_1for_1flutter_NativeLibrary_startLogging(env, nullptr);
        } else {
            Common::Log::Initialize();
        }
        step = "the settings";
        Config{};
        if (host_state != nullptr) {
            if (host_state->gpu_driver_initialized != 0) {
                step = "the GPU driver";
                InitializeGpuDriver(host_state->hook_lib_dir, host_state->custom_driver_dir,
                                    host_state->custom_driver_name,
                                    host_state->file_redirect_dir);
            }
        }
    } catch (const std::exception& exception) {
        g_session_library_error =
            std::string{"initializing "} + step + " threw " + exception.what();
        return AZAHAR_STATUS_LOAD_FAILED;
    } catch (...) {
        g_session_library_error =
            std::string{"initializing "} + step + " threw an unknown exception";
        return AZAHAR_STATUS_LOAD_FAILED;
    }
    return AZAHAR_STATUS_OK;
}

/**
 * Stops everything the library started on its own and releases its references, so it can be
 * unloaded.
 */
static void ShutdownSessionLibraryUnguarded() {
    if (logging_started) {
        Common::Log::Stop();
        logging_started = false;
    }
    IDCache::ReleaseForSession();
}

} // extern "C"

namespace {

/// An exception must never leave the library through the C ABI, because the caller is Rust and
/// cannot unwind it.
void ReportNativeException(const char* where, const std::exception* exception) {
    __android_log_print(ANDROID_LOG_ERROR, "azahar-session", "%s threw %s", where,
                        exception != nullptr ? exception->what() : "an unknown exception");
}

template <typename Result, typename Function>
Result Guarded(const char* where, Result fallback, Function&& function) {
    try {
        return function();
    } catch (const std::exception& exception) {
        ReportNativeException(where, &exception);
    } catch (...) {
        ReportNativeException(where, nullptr);
    }
    return fallback;
}

template <typename Function>
void GuardedVoid(const char* where, Function&& function) {
    try {
        function();
    } catch (const std::exception& exception) {
        ReportNativeException(where, &exception);
    } catch (...) {
        ReportNativeException(where, nullptr);
    }
}

} // Anonymous namespace

extern "C" {

AzaharSession* azahar_session_create(const char* game_path, const AzaharSessionOptions* options,
                                     const AzaharSessionCallbacks* callbacks) {
    return Guarded<AzaharSession*>("azahar_session_create", nullptr, [&] {
        return CreateSessionUnguarded(game_path, options, callbacks);
    });
}

int32_t azahar_session_start(AzaharSession* session) {
    return Guarded<int32_t>("azahar_session_start", AZAHAR_STATUS_LOAD_FAILED,
                            [&] { return StartSessionUnguarded(session); });
}

void azahar_session_destroy(AzaharSession* session) {
    GuardedVoid("azahar_session_destroy", [&] { DestroySessionUnguarded(session); });
}

void azahar_host_bind_natives(void* session_library) {
    GuardedVoid("azahar_host_bind_natives", [&] { BindNativesUnguarded(session_library); });
}

int32_t azahar_session_lib_init(void* java_vm, void* app_class_loader,
                                const AzaharHostState* host_state) {
    return Guarded<int32_t>("azahar_session_lib_init", AZAHAR_STATUS_LOAD_FAILED, [&] {
        return InitSessionLibraryUnguarded(java_vm, app_class_loader, host_state);
    });
}

void azahar_session_lib_shutdown() {
    GuardedVoid("azahar_session_lib_shutdown", [] { ShutdownSessionLibraryUnguarded(); });
}

} // extern "C"
