// Copyright 2019 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include "common/android_storage.h"
#include "common/common_paths.h"
#include "common/logging/backend.h"
#include "common/logging/filter.h"
#include "common/logging/log.h"
#include "common/settings.h"
#include "core/hle/service/am/am.h"
#include "jni/applets/mii_selector.h"
#include "jni/applets/swkbd.h"
#include "jni/camera/still_image_camera.h"
#include "jni/id_cache.h"

#include <algorithm>
#include <string>
#include <unordered_map>

#include <jni.h>

static constexpr jint JNI_VERSION = JNI_VERSION_1_6;

static JavaVM* s_java_vm;
static jobject s_app_class_loader;

static jclass s_core_error_class;
static jclass s_savestate_info_class;

static jclass s_native_library_class;
static jmethodID s_on_core_error;
static jmethodID s_is_portrait_mode;
static jmethodID s_landscape_screen_layout;
static jmethodID s_portrait_screen_layout;
static jmethodID s_exit_emulation_activity;
static jmethodID s_request_camera_permission;
static jmethodID s_request_mic_permission;
static jmethodID s_request_wifi_permission;
static jmethodID s_scan_wifi_access_points;
static jmethodID s_create_session_texture;
static jmethodID s_get_session_surface;
static jmethodID s_release_session_textures;

static jclass s_cheat_class;
static jfieldID s_cheat_pointer;
static jmethodID s_cheat_constructor;

static jfieldID s_game_info_pointer;

static jclass s_disk_cache_progress_class;
static jmethodID s_disk_cache_load_progress;
static std::unordered_map<VideoCore::LoadCallbackStage, jobject> s_java_load_callback_stages;

static jclass s_cia_install_helper_class;
static jmethodID s_cia_install_helper_set_progress;
static std::unordered_map<Service::AM::InstallStatus, jobject> s_java_cia_install_status;

namespace IDCache {

JNIEnv* GetEnvForThread() {
    thread_local static struct OwnedEnv {
        OwnedEnv() {
            status = s_java_vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6);
            if (status == JNI_EDETACHED)
                s_java_vm->AttachCurrentThread(&env, nullptr);
        }

        ~OwnedEnv() {
            if (status == JNI_EDETACHED)
                s_java_vm->DetachCurrentThread();
        }

        int status;
        JNIEnv* env = nullptr;
    } owned;
    return owned.env;
}

JavaVM* GetJavaVM() {
    return s_java_vm;
}

jobject GetAppClassLoader() {
    return s_app_class_loader;
}

jclass FindClass(JNIEnv* env, const char* name) {
    if (s_app_class_loader == nullptr) {
        return env->FindClass(name);
    }
    const jclass loader_class = env->GetObjectClass(s_app_class_loader);
    const jmethodID load_class =
        env->GetMethodID(loader_class, "loadClass", "(Ljava/lang/String;)Ljava/lang/Class;");
    env->DeleteLocalRef(loader_class);

    std::string dotted_name{name};
    std::replace(dotted_name.begin(), dotted_name.end(), '/', '.');
    const jstring j_name = env->NewStringUTF(dotted_name.c_str());
    const auto found =
        static_cast<jclass>(env->CallObjectMethod(s_app_class_loader, load_class, j_name));
    env->DeleteLocalRef(j_name);
    if (env->ExceptionCheck()) {
        env->ExceptionClear();
        return nullptr;
    }
    return found;
}

jclass GetCoreErrorClass() {
    return s_core_error_class;
}

jclass GetSavestateInfoClass() {
    return s_savestate_info_class;
}

jclass GetNativeLibraryClass() {
    return s_native_library_class;
}

jmethodID GetOnCoreError() {
    return s_on_core_error;
}

jmethodID GetIsPortraitMode() {
    return s_is_portrait_mode;
}

jmethodID GetLandscapeScreenLayout() {
    return s_landscape_screen_layout;
}

jmethodID GetPortraitScreenLayout() {
    return s_portrait_screen_layout;
}

jmethodID GetExitEmulationActivity() {
    return s_exit_emulation_activity;
}

jmethodID GetRequestCameraPermission() {
    return s_request_camera_permission;
}

jmethodID GetRequestMicPermission() {
    return s_request_mic_permission;
}

jmethodID GetRequestWifiPermission() {
    return s_request_wifi_permission;
}

jmethodID GetScanWifiAccessPoints() {
    return s_scan_wifi_access_points;
}

jmethodID GetCreateSessionTexture() {
    return s_create_session_texture;
}

jmethodID GetGetSessionSurface() {
    return s_get_session_surface;
}

jmethodID GetReleaseSessionTextures() {
    return s_release_session_textures;
}

jclass GetCheatClass() {
    return s_cheat_class;
}

jfieldID GetCheatPointer() {
    return s_cheat_pointer;
}

jmethodID GetCheatConstructor() {
    return s_cheat_constructor;
}

jfieldID GetGameInfoPointer() {
    return s_game_info_pointer;
}

jclass GetDiskCacheProgressClass() {
    return s_disk_cache_progress_class;
}

jmethodID GetDiskCacheLoadProgress() {
    return s_disk_cache_load_progress;
}

jobject GetJavaLoadCallbackStage(VideoCore::LoadCallbackStage stage) {
    const auto it = s_java_load_callback_stages.find(stage);
    ASSERT_MSG(it != s_java_load_callback_stages.end(), "Invalid LoadCallbackStage: {}", stage);

    return it->second;
}

jclass GetCiaInstallHelperClass() {
    return s_cia_install_helper_class;
}

jmethodID GetCiaInstallHelperSetProgress() {
    return s_cia_install_helper_set_progress;
}
jobject GetJavaCiaInstallStatus(Service::AM::InstallStatus status) {
    const auto it = s_java_cia_install_status.find(status);
    ASSERT_MSG(it != s_java_cia_install_status.end(), "Invalid InstallStatus: {}", status);

    return it->second;
}
} // namespace IDCache

#ifdef __cplusplus
extern "C" {
#endif

static jint InitializeIds(JNIEnv* env) {
    // Initialize misc classes
    s_savestate_info_class = reinterpret_cast<jclass>(
        env->NewGlobalRef(IDCache::FindClass(env,"com/karasu256/azahar_reloaded/lib/azahar_for_flutter/NativeLibrary$SaveStateInfo")));
    s_core_error_class = reinterpret_cast<jclass>(
        env->NewGlobalRef(IDCache::FindClass(env,"com/karasu256/azahar_reloaded/lib/azahar_for_flutter/NativeLibrary$CoreError")));

    // Initialize NativeLibrary
    const jclass native_library_class = IDCache::FindClass(env,"com/karasu256/azahar_reloaded/lib/azahar_for_flutter/NativeLibrary");
    s_native_library_class = reinterpret_cast<jclass>(env->NewGlobalRef(native_library_class));
    s_on_core_error = env->GetStaticMethodID(
        s_native_library_class, "onCoreError",
        "(Lcom/karasu256/azahar_reloaded/lib/azahar_for_flutter/NativeLibrary$CoreError;Ljava/lang/String;)Z");
    s_is_portrait_mode = env->GetStaticMethodID(s_native_library_class, "isPortraitMode", "()Z");
    s_exit_emulation_activity =
        env->GetStaticMethodID(s_native_library_class, "exitEmulationActivity", "(I)V");
    s_request_camera_permission =
        env->GetStaticMethodID(s_native_library_class, "requestCameraPermission", "()Z");
    s_request_mic_permission =
        env->GetStaticMethodID(s_native_library_class, "requestMicPermission", "()Z");
    s_request_wifi_permission =
        env->GetStaticMethodID(s_native_library_class, "requestWifiPermission", "()Z");
    s_scan_wifi_access_points = env->GetStaticMethodID(s_native_library_class,
                                                       "scanWifiAccessPoints",
                                                       "()[Ljava/lang/String;");
    s_create_session_texture =
        env->GetStaticMethodID(s_native_library_class, "createSessionTexture", "(IIZ)J");
    s_get_session_surface = env->GetStaticMethodID(s_native_library_class, "getSessionSurface",
                                                   "(Z)Landroid/view/Surface;");
    s_release_session_textures =
        env->GetStaticMethodID(s_native_library_class, "releaseSessionTextures", "()V");
    env->DeleteLocalRef(native_library_class);

    // Initialize Cheat
    const jclass cheat_class = IDCache::FindClass(env,"com/karasu256/azahar_reloaded/lib/azahar_for_flutter/features/cheats/model/Cheat");
    s_cheat_class = reinterpret_cast<jclass>(env->NewGlobalRef(cheat_class));
    s_cheat_pointer = env->GetFieldID(cheat_class, "mPointer", "J");
    s_cheat_constructor = env->GetMethodID(cheat_class, "<init>", "(J)V");
    env->DeleteLocalRef(cheat_class);

    // Initialize GameInfo
    const jclass game_info_class = IDCache::FindClass(env,"com/karasu256/azahar_reloaded/lib/azahar_for_flutter/model/GameInfo");
    s_game_info_pointer = env->GetFieldID(game_info_class, "pointer", "J");
    env->DeleteLocalRef(game_info_class);

    // Initialize Disk Shader Cache Progress Dialog
    s_disk_cache_progress_class = reinterpret_cast<jclass>(
        env->NewGlobalRef(IDCache::FindClass(env,"com/karasu256/azahar_reloaded/lib/azahar_for_flutter/utils/DiskShaderCacheProgress")));
    jclass load_callback_stage_class =
        IDCache::FindClass(env,"com/karasu256/azahar_reloaded/lib/azahar_for_flutter/utils/DiskShaderCacheProgress$LoadCallbackStage");
    s_disk_cache_load_progress = env->GetStaticMethodID(
        s_disk_cache_progress_class, "loadProgress",
        "(Lcom/karasu256/azahar_reloaded/lib/azahar_for_flutter/utils/DiskShaderCacheProgress$LoadCallbackStage;II)V");
    // Initialize LoadCallbackStage map
    const auto to_java_load_callback_stage = [env,
                                              load_callback_stage_class](const std::string& stage) {
        return env->NewGlobalRef(env->GetStaticObjectField(
            load_callback_stage_class,
            env->GetStaticFieldID(load_callback_stage_class, stage.c_str(),
                                  "Lcom/karasu256/azahar_reloaded/lib/azahar_for_flutter/utils/"
                                  "DiskShaderCacheProgress$LoadCallbackStage;")));
    };
    s_java_load_callback_stages.emplace(VideoCore::LoadCallbackStage::Prepare,
                                        to_java_load_callback_stage("Prepare"));
    s_java_load_callback_stages.emplace(VideoCore::LoadCallbackStage::Decompile,
                                        to_java_load_callback_stage("Decompile"));
    s_java_load_callback_stages.emplace(VideoCore::LoadCallbackStage::Build,
                                        to_java_load_callback_stage("Build"));
    s_java_load_callback_stages.emplace(VideoCore::LoadCallbackStage::Complete,
                                        to_java_load_callback_stage("Complete"));
    env->DeleteLocalRef(load_callback_stage_class);

    // CIA Install
    s_cia_install_helper_class = reinterpret_cast<jclass>(
        env->NewGlobalRef(IDCache::FindClass(env,"com/karasu256/azahar_reloaded/lib/azahar_for_flutter/utils/CiaInstallWorker")));
    s_cia_install_helper_set_progress =
        env->GetMethodID(s_cia_install_helper_class, "setProgressCallback", "(II)V");
    // Initialize CIA InstallStatus map
    jclass cia_install_status_class =
        IDCache::FindClass(env,"com/karasu256/azahar_reloaded/lib/azahar_for_flutter/NativeLibrary$InstallStatus");
    const auto to_java_cia_install_status = [env,
                                             cia_install_status_class](const std::string& stage) {
        return env->NewGlobalRef(env->GetStaticObjectField(
            cia_install_status_class, env->GetStaticFieldID(cia_install_status_class, stage.c_str(),
                                                            "Lcom/karasu256/azahar_reloaded/lib/azahar_for_flutter/"
                                                            "NativeLibrary$InstallStatus;")));
    };
    s_java_cia_install_status.emplace(Service::AM::InstallStatus::Success,
                                      to_java_cia_install_status("Success"));
    s_java_cia_install_status.emplace(Service::AM::InstallStatus::ErrorFailedToOpenFile,
                                      to_java_cia_install_status("ErrorFailedToOpenFile"));
    s_java_cia_install_status.emplace(Service::AM::InstallStatus::ErrorFileNotFound,
                                      to_java_cia_install_status("ErrorFileNotFound"));
    s_java_cia_install_status.emplace(Service::AM::InstallStatus::ErrorAborted,
                                      to_java_cia_install_status("ErrorAborted"));
    s_java_cia_install_status.emplace(Service::AM::InstallStatus::ErrorInvalid,
                                      to_java_cia_install_status("ErrorInvalid"));
    s_java_cia_install_status.emplace(Service::AM::InstallStatus::ErrorEncrypted,
                                      to_java_cia_install_status("ErrorEncrypted"));
    env->DeleteLocalRef(cia_install_status_class);

    MiiSelector::InitJNI(env);
    SoftwareKeyboard::InitJNI(env);
    Camera::StillImage::InitJNI(env);
    AndroidStorage::InitJNI(env, s_native_library_class);

    return JNI_VERSION;
}

static void ReleaseIds(JNIEnv* env) {
    env->DeleteGlobalRef(s_savestate_info_class);
    env->DeleteGlobalRef(s_core_error_class);
    env->DeleteGlobalRef(s_disk_cache_progress_class);
    env->DeleteGlobalRef(s_native_library_class);
    env->DeleteGlobalRef(s_cheat_class);
    env->DeleteGlobalRef(s_cia_install_helper_class);

    for (auto& [key, object] : s_java_load_callback_stages) {
        env->DeleteGlobalRef(object);
    }

    for (auto& [key, object] : s_java_cia_install_status) {
        env->DeleteGlobalRef(object);
    }

    MiiSelector::CleanupJNI(env);
    SoftwareKeyboard::CleanupJNI(env);
    Camera::StillImage::CleanupJNI(env);
    AndroidStorage::CleanupJNI();
    s_java_load_callback_stages.clear();
    s_java_cia_install_status.clear();
}

jint JNI_OnLoad(JavaVM* vm, void* reserved) {
    s_java_vm = vm;

    JNIEnv* env;
    if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION) != JNI_OK)
        return JNI_ERR;

    const jclass native_library_class = env->FindClass("com/karasu256/azahar_reloaded/lib/azahar_for_flutter/NativeLibrary");
    const jclass class_class = env->GetObjectClass(native_library_class);
    const jmethodID get_class_loader =
        env->GetMethodID(class_class, "getClassLoader", "()Ljava/lang/ClassLoader;");
    s_app_class_loader =
        env->NewGlobalRef(env->CallObjectMethod(native_library_class, get_class_loader));
    env->DeleteLocalRef(class_class);
    env->DeleteLocalRef(native_library_class);

    return InitializeIds(env);
}

void JNI_OnUnload(JavaVM* vm, void* reserved) {
    JNIEnv* env;
    if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION) != JNI_OK) {
        return;
    }
    ReleaseIds(env);
    env->DeleteGlobalRef(s_app_class_loader);
    s_app_class_loader = nullptr;
}

#ifdef __cplusplus
}
#endif

namespace IDCache {

bool InitializeForSession(JavaVM* vm, jobject app_class_loader) {
    s_java_vm = vm;
    JNIEnv* env = GetEnvForThread();
    s_app_class_loader = env->NewGlobalRef(app_class_loader);
    const bool initialized = InitializeIds(env) == JNI_VERSION;
    if (env->ExceptionCheck()) {
        env->ExceptionDescribe();
    }
    return initialized;
}

void ReleaseForSession() {
    JNIEnv* env = GetEnvForThread();
    ReleaseIds(env);
    env->DeleteGlobalRef(s_app_class_loader);
    s_app_class_loader = nullptr;
}

} // namespace IDCache
