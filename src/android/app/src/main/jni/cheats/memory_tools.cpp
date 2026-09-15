// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include <vector>

#include <jni.h>

#include "common/common_types.h"
#include "core/core.h"
#include "core/memory_tools.h"
#include "jni/android_common/android_common.h"

extern "C" {

static Core::MemoryRecorder& GetRecorder() {
    Core::System& system{Core::System::GetInstance()};
    return system.MemoryTools();
}

JNIEXPORT jbyteArray JNICALL
Java_org_citra_citra_1emu_NativeLibrary_dumpCurrentMemory(JNIEnv* env, jclass) {
    Core::System& system{Core::System::GetInstance()};
    const std::vector<u8> memory = Core::DumpFCRAM(system);

    const jbyteArray array = env->NewByteArray(static_cast<jsize>(memory.size()));
    env->SetByteArrayRegion(array, 0, static_cast<jsize>(memory.size()),
                            reinterpret_cast<const jbyte*>(memory.data()));
    return array;
}

JNIEXPORT void JNICALL Java_org_citra_citra_1emu_NativeLibrary_startMemoryRecording(
    JNIEnv* env, jclass, jstring j_output_dir, jint j_interval_frames) {
    const std::string output_dir = GetJString(env, j_output_dir);
    GetRecorder().StartRecording(output_dir, static_cast<u32>(j_interval_frames));
}

JNIEXPORT jint JNICALL
Java_org_citra_citra_1emu_NativeLibrary_stopMemoryRecording(JNIEnv* env, jclass) {
    return static_cast<jint>(GetRecorder().StopRecording());
}
}
