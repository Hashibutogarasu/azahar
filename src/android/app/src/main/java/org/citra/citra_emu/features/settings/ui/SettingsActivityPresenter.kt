// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.settings.ui

import android.os.Bundle
import org.citra.citra_emu.NativeLibrary
import org.citra.citra_emu.features.settings.data.AppSettingsRepository
import org.citra.citra_emu.features.settings.model.IntSetting
import org.citra.citra_emu.features.settings.model.Settings
import org.citra.citra_emu.utils.SystemSaveGame
import org.citra.citra_emu.utils.DirectoryInitialization
import org.citra.citra_emu.utils.Log

class SettingsActivityPresenter(
    private val activityView: SettingsActivityView,
    private val appSettings: AppSettingsRepository
) {
    val settings: Settings get() = activityView.settings

    private var shouldSave = false
    private lateinit var menuTag: String
    private lateinit var gameId: String

    fun onCreate(savedInstanceState: Bundle?, menuTag: String, gameId: String) {
        this.menuTag = menuTag
        this.gameId = gameId
        if (savedInstanceState != null) {
            shouldSave = savedInstanceState.getBoolean(KEY_SHOULD_SAVE)
        }
    }

    fun onResume() {}

    fun onPause() {
        SystemSaveGame.save()
    }

    fun onStart() {
        if (!DirectoryInitialization.areCitraDirectoriesReady()) {
            DirectoryInitialization.start()
        }
    }

    fun onStop(finishing: Boolean) {
        if (finishing && shouldSave) {
            Log.debug("[SettingsActivity] Settings activity stopping. Saving settings to INI...")
            settings.saveSettings(activityView)
            //added to ensure that layout changes take effect as soon as settings window closes
            NativeLibrary.reloadSettings()
            NativeLibrary.updateFramebuffer(NativeLibrary.isPortraitMode)
        }
        NativeLibrary.reloadSettings()

        if (finishing && appSettings.applyPendingLanguage()) {
            activityView.restartApp()
        }
    }

    fun onSettingChanged() {
        shouldSave = true
    }

    fun onSettingsReset() {
        shouldSave = false
    }

    fun saveState(outState: Bundle) {
        outState.putBoolean(KEY_SHOULD_SAVE, shouldSave)
    }

    companion object {
        private const val KEY_SHOULD_SAVE = "should_save"
    }
}
