// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.utils

import org.citra.citra_emu.applets.MiiSelector
import org.citra.citra_emu.applets.SoftwareKeyboard

object AppletBridge {
    interface Listener {
        fun showKeyboard(
            config: SoftwareKeyboard.KeyboardConfig,
            callback: (button: Int, text: String) -> Unit
        )

        fun showMiiSelector(
            config: MiiSelector.MiiSelectorConfig,
            callback: (returnCode: Long, index: Int) -> Unit
        )

        fun showKeyboardError(message: String)
    }

    var listener: Listener? = null
}
