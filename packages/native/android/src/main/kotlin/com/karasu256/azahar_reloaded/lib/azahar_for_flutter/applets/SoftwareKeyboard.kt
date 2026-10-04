// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.applets

import android.text.Spanned
import android.text.InputFilter
import androidx.annotation.Keep
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.NativeLibrary
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.AppletBridge
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.Log
import java.io.Serializable
import java.util.concurrent.CountDownLatch

@Keep
object SoftwareKeyboard {
    @JvmStatic
    fun Execute(config: KeyboardConfig): KeyboardData {
        if (config.buttonConfig == ButtonConfig.None) {
            Log.error("Unexpected button config None")
            return KeyboardData(0, "")
        }

        val latch = CountDownLatch(1)
        var result = KeyboardData(0, "")
        val emulationActivity = NativeLibrary.sEmulationActivity.get()
        emulationActivity?.runOnUiThread {
            val listener = AppletBridge.listener
            if (listener == null) {
                latch.countDown()
                return@runOnUiThread
            }
            listener.showKeyboard(config) { button, text ->
                result = KeyboardData(button, text)
                latch.countDown()
            }
        } ?: latch.countDown()

        try {
            latch.await()
        } catch (ignored: InterruptedException) {
        }
        return result
    }

    @JvmStatic
    fun ShowError(error: String) {
        val emulationActivity = NativeLibrary.sEmulationActivity.get()
        emulationActivity?.runOnUiThread {
            AppletBridge.listener?.showKeyboardError(error)
        }
    }

    private external fun ValidateFilters(text: String): ValidationError
    external fun ValidateInput(text: String): ValidationError

    interface ButtonConfig {
        companion object {
            const val Single = 0
            const val Dual = 1
            const val Triple = 2
            const val None = 3
        }
    }

    enum class ValidationError {
        None,
        ButtonOutOfRange,
        MaxDigitsExceeded,
        AtSignNotAllowed,
        PercentNotAllowed,
        BackslashNotAllowed,
        ProfanityNotAllowed,
        CallbackFailed,
        FixedLengthRequired,
        MaxLengthExceeded,
        BlankInputNotAllowed,
        EmptyInputNotAllowed
    }

    @Keep
    class KeyboardConfig : Serializable {
        var buttonConfig = 0
        var maxTextLength = 0
        var multilineMode = false
        var hintText: String? = null
        lateinit var buttonText: Array<String>
    }

    class KeyboardData(var button: Int, var text: String)

    class Filter : InputFilter {
        override fun filter(
            source: CharSequence,
            start: Int,
            end: Int,
            dest: Spanned,
            dstart: Int,
            dend: Int
        ): CharSequence? {
            val text = StringBuilder(dest)
                .replace(dstart, dend, source.subSequence(start, end).toString())
                .toString()
            return if (ValidateFilters(text) == ValidationError.None) {
                null
            } else {
                dest.subSequence(dstart, dend)
            }
        }
    }
}
