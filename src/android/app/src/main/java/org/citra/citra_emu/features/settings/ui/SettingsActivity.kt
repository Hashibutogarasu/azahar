// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.settings.ui

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.widget.Toast
import androidx.activity.compose.setContent
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.core.view.WindowCompat
import androidx.navigation.compose.rememberNavController
import androidx.preference.PreferenceManager
import com.ramcosta.composedestinations.DestinationsNavHost
import com.ramcosta.composedestinations.generated.NavGraphs
import com.ramcosta.composedestinations.generated.destinations.SettingsSectionScreenDestination
import com.ramcosta.composedestinations.navigation.dependency
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.NativeLibrary
import org.citra.citra_emu.R
import org.citra.citra_emu.features.settings.model.BooleanSetting
import java.io.IOException
import org.citra.citra_emu.features.settings.model.FloatSetting
import org.citra.citra_emu.features.settings.model.IntSetting
import org.citra.citra_emu.features.settings.model.ScaledFloatSetting
import org.citra.citra_emu.features.settings.model.Settings
import org.citra.citra_emu.features.settings.model.SettingsViewModel
import org.citra.citra_emu.features.settings.model.StringSetting
import org.citra.citra_emu.features.settings.ui.compose.SettingsSectionScreen
import org.citra.citra_emu.features.settings.utils.SettingsFile
import org.citra.citra_emu.ui.compose.theme.AzaharTheme
import org.citra.citra_emu.ui.main.MainActivity
import org.citra.citra_emu.utils.DirectoryInitialization
import org.citra.citra_emu.utils.Log
import org.citra.citra_emu.utils.SystemSaveGame
import org.citra.citra_emu.utils.ThemeUtil

class SettingsActivity : AppCompatActivity(), SettingsActivityView {
    private val settingsViewModel: SettingsViewModel by viewModels()

    override val settings: Settings get() = settingsViewModel.settings

    var currentToolbarTitle by mutableStateOf("")
        private set

    override fun onCreate(savedInstanceState: Bundle?) {
        ThemeUtil.setTheme(this)

        super.onCreate(savedInstanceState)

        WindowCompat.setDecorFitsSystemWindows(window, false)

        settingsViewModel.restoreState(savedInstanceState)

        val launcher = intent
        val gameID = launcher.getStringExtra(ARG_GAME_ID)
        val menuTag = launcher.getStringExtra(ARG_MENU_TAG)

        setContent {
            AzaharTheme {
                var settingsReady by remember { mutableStateOf(false) }
                LaunchedEffect(Unit) {
                    settingsViewModel.prepareAll(gameID, this@SettingsActivity)
                    settingsReady = true
                }

                if (settingsReady) {
                    val navController = rememberNavController()
                    DestinationsNavHost(
                        navGraph = NavGraphs.root,
                        start = SettingsSectionScreenDestination(menuTag = menuTag, gameId = gameID),
                        navController = navController,
                        dependenciesContainerBuilder = {
                            dependency(settingsViewModel)
                        }
                    )
                } else {
                    Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        CircularProgressIndicator()
                    }
                }
            }
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        settingsViewModel.saveState(outState)
    }

    override fun onPause() {
        super.onPause()
        settingsViewModel.onPause()
    }

    override fun onStart() {
        super.onStart()
        settingsViewModel.onStart()
    }

    /**
     * If this is called, the user has left the settings screen (potentially through the
     * home button) and will expect their changes to be persisted. So we kick off an
     * IntentService which will do so on a background thread.
     */
    override fun onStop() {
        super.onStop()
        settingsViewModel.onStop(isFinishing, this)
    }

    override fun onSettingsFileNotFound() {
        Log.error("[SettingsActivity] Settings file not found.")
    }

    override fun showToastMessage(message: String, isLong: Boolean) {
        Toast.makeText(
            this,
            message,
            if (isLong) Toast.LENGTH_LONG else Toast.LENGTH_SHORT
        ).show()
    }

    override fun onSettingChanged() {
        settingsViewModel.onSettingChanged()
    }

    override fun restartApp() {
        val restart = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        startActivity(restart)
    }

    fun onSettingsReset() {
        settingsViewModel.onSettingsReset()

        val controllerKeys = Settings.buttonKeys + Settings.circlePadKeys + Settings.cStickKeys +
                Settings.dPadAxisKeys + Settings.dPadButtonKeys + Settings.triggerKeys
        val editor =
            PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext).edit()
        controllerKeys.forEach { editor.remove(it) }
        editor.apply()

        BooleanSetting.clear()
        FloatSetting.clear()
        ScaledFloatSetting.clear()
        IntSetting.clear()
        StringSetting.clear()

        val settingsFile = SettingsFile.getSettingsFile(SettingsFile.FILE_NAME_CONFIG)
        if (!settingsFile.delete()) {
            throw IOException("Failed to delete $settingsFile")
        }

        if (DirectoryInitialization.setCitraUserDirectory()) {
            CitraApplication.documentsTree.setRoot(Uri.parse(DirectoryInitialization.userPath))
            NativeLibrary.createConfigFile()
        } else {
            throw IllegalStateException("Azahar directory unavailable when accessing config file!")
        }

        SystemSaveGame.apply {
            setUsername("AZAHAR")
            setBirthday(11, 7)
            setSystemLanguage(1)
            setSoundOutputMode(1)
            setCountryCode(49)
            setPlayCoins(42)
        }

        showToastMessage(getString(R.string.settings_reset), true)
        finish()
    }

    fun setToolbarTitle(title: String) {
        currentToolbarTitle = title
    }

    companion object {
        private const val ARG_MENU_TAG = "menu_tag"
        private const val ARG_GAME_ID = "game_id"

        @JvmStatic
        fun launch(context: Context, menuTag: String?, gameId: String?) {
            val settings = Intent(context, SettingsActivity::class.java)
            settings.putExtra(ARG_MENU_TAG, menuTag)
            settings.putExtra(ARG_GAME_ID, gameId)
            context.startActivity(settings)
        }

        fun launch(
            context: Context,
            launcher: ActivityResultLauncher<Intent>,
            menuTag: String?,
            gameId: String?
        ) {
            val settings = Intent(context, SettingsActivity::class.java)
            settings.putExtra(ARG_MENU_TAG, menuTag)
            settings.putExtra(ARG_GAME_ID, gameId)
            launcher.launch(settings)
        }
    }
}
