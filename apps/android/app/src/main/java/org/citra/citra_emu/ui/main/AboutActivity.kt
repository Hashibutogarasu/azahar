// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.main

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.activity.compose.setContent
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.WindowCompat
import androidx.navigation.compose.rememberNavController
import com.ramcosta.composedestinations.DestinationsNavHost
import com.ramcosta.composedestinations.generated.NavGraphs
import com.ramcosta.composedestinations.generated.destinations.AboutScreenDestination
import org.citra.citra_emu.ui.compose.theme.AzaharTheme
import org.citra.citra_emu.utils.ThemeUtil

/**
 * Hosts [org.citra.citra_emu.ui.main.compose.AboutScreen] (and the
 * [org.citra.citra_emu.ui.main.compose.LicensesScreen] reachable from it) as its own standalone
 * Activity, matching [org.citra.citra_emu.features.settings.ui.SettingsActivity]'s navigation
 * approach (a dedicated Activity with the OS's default transition) instead of being composed in
 * place inside [MainActivity] with the bottom navigation bar hidden.
 */
class AboutActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        ThemeUtil.setTheme(this)

        super.onCreate(savedInstanceState)

        WindowCompat.setDecorFitsSystemWindows(window, false)

        setContent {
            AzaharTheme {
                DestinationsNavHost(
                    navGraph = NavGraphs.root,
                    start = AboutScreenDestination,
                    navController = rememberNavController()
                )
            }
        }
    }

    companion object {
        @JvmStatic
        fun launch(context: Context) {
            context.startActivity(Intent(context, AboutActivity::class.java))
        }
    }
}
