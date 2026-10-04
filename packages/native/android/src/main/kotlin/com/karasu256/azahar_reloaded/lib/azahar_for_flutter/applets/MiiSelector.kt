// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.applets

import androidx.annotation.Keep
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.NativeLibrary
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.AppletBridge
import java.io.Serializable
import java.util.concurrent.CountDownLatch

@Keep
object MiiSelector {
    @JvmStatic
    fun Execute(config: MiiSelectorConfig): MiiSelectorData {
        val latch = CountDownLatch(1)
        var result = MiiSelectorData(0, 0)
        val emulationActivity = NativeLibrary.sEmulationActivity.get()
        emulationActivity?.runOnUiThread {
            val listener = AppletBridge.listener
            if (listener == null) {
                latch.countDown()
                return@runOnUiThread
            }
            listener.showMiiSelector(config) { returnCode, index ->
                result = MiiSelectorData(returnCode, index)
                latch.countDown()
            }
        } ?: latch.countDown()

        try {
            latch.await()
        } catch (ignored: InterruptedException) {
        }
        return result
    }

    @Keep
    class MiiSelectorConfig : Serializable {
        var enableCancelButton = false
        var title: String? = null
        var initiallySelectedMiiIndex: Long = 0
        lateinit var miiNames: Array<String>
    }

    class MiiSelectorData(var returnCode: Long, var index: Int)
}
