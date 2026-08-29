// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.cheats.ui

import android.os.Bundle
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.WindowCompat
import org.citra.citra_emu.features.cheats.model.CheatsViewModel
import org.citra.citra_emu.features.cheats.ui.compose.CheatsScreen
import org.citra.citra_emu.ui.compose.theme.AzaharTheme
import org.citra.citra_emu.utils.ThemeUtil

class CheatsActivity : AppCompatActivity() {
    private val cheatsViewModel: CheatsViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        ThemeUtil.setTheme(this)

        super.onCreate(savedInstanceState)

        WindowCompat.setDecorFitsSystemWindows(window, false)

        cheatsViewModel.initialize(intent.getLongExtra(EXTRA_TITLE_ID, -1L))

        setContent {
            AzaharTheme {
                CheatsScreen(
                    cheatsViewModel = cheatsViewModel,
                    onNavigateBack = { finish() }
                )
            }
        }
    }

    override fun onStop() {
        super.onStop()
        cheatsViewModel.saveIfNeeded()
    }

    companion object {
        /** Matches the `titleId` argument name used by the `cheatsActivity`
         *  destination in `emulation_navigation.xml`. */
        private const val EXTRA_TITLE_ID = "titleId"
    }
}
