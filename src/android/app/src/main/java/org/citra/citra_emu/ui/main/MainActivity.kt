// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.main

import android.os.Bundle
import android.view.WindowManager
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.core.view.WindowCompat
import org.citra.citra_emu.features.settings.model.SettingsViewModel
import org.citra.citra_emu.ui.compose.theme.AzaharTheme
import org.citra.citra_emu.ui.main.compose.MainScreen
import org.citra.citra_emu.utils.CitraDirectoryUtils
import org.citra.citra_emu.utils.DirectoryInitialization
import org.citra.citra_emu.utils.PermissionsHandler
import org.citra.citra_emu.utils.ThemeUtil
import org.citra.citra_emu.viewmodel.DriverViewModel
import org.citra.citra_emu.viewmodel.GamesViewModel
import org.citra.citra_emu.viewmodel.HomeViewModel
import org.citra.citra_emu.viewmodel.TaskViewModel

class MainActivity : AppCompatActivity(), ThemeProvider {
    private val homeViewModel: HomeViewModel by viewModels()
    private val gamesViewModel: GamesViewModel by viewModels()
    private val driverViewModel: DriverViewModel by viewModels()
    private val taskViewModel: TaskViewModel by viewModels()
    private val settingsViewModel: SettingsViewModel by viewModels()

    override var themeId: Int = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        val splashScreen = installSplashScreen()
        CitraDirectoryUtils.attemptAutomaticUpdateDirectory()
        splashScreen.setKeepOnScreenCondition {
            !DirectoryInitialization.areCitraDirectoriesReady() &&
                    PermissionsHandler.hasWriteAccess(this) &&
                    !CitraDirectoryUtils.needToUpdateManually()
        }

        if (PermissionsHandler.hasWriteAccess(applicationContext) &&
            DirectoryInitialization.areCitraDirectoriesReady() &&
            !CitraDirectoryUtils.needToUpdateManually()
        ) {
            settingsViewModel.settings.loadSettings()
        }

        ThemeUtil.ThemeChangeListener(this)
        ThemeUtil.setTheme(this)
        super.onCreate(savedInstanceState)

        WindowCompat.setDecorFitsSystemWindows(window, false)
        window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_NOTHING)
        window.statusBarColor = ContextCompat.getColor(applicationContext, android.R.color.transparent)
        window.navigationBarColor = ContextCompat.getColor(applicationContext, android.R.color.transparent)

        setContent {
            AzaharTheme {
                MainScreen(
                    homeViewModel = homeViewModel,
                    gamesViewModel = gamesViewModel,
                    driverViewModel = driverViewModel,
                    taskViewModel = taskViewModel
                )
            }
        }
    }

    override fun onResume() {
        ThemeUtil.setCorrectTheme(this)
        super.onResume()
    }

    override fun setTheme(resId: Int) {
        super.setTheme(resId)
        themeId = resId
    }
}
