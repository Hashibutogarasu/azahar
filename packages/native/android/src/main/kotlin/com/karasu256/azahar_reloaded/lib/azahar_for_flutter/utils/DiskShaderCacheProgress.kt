// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils

import androidx.annotation.Keep
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.NativeLibrary

@Keep
object DiskShaderCacheProgress {
    var listener: Listener? = null

    @JvmStatic
    fun loadProgress(stage: LoadCallbackStage, progress: Int, max: Int) {
        val emulationActivity = NativeLibrary.sEmulationActivity.get()
        if (emulationActivity == null) {
            Log.error("[DiskShaderCacheProgress] EmulationActivity not present")
            return
        }

        emulationActivity.runOnUiThread {
            listener?.onLoadProgress(stage, progress, max)
        }
    }

    fun interface Listener {
        fun onLoadProgress(stage: LoadCallbackStage, progress: Int, max: Int)
    }

    enum class LoadCallbackStage {
        Prepare,
        Decompile,
        Build,
        Complete
    }
}
