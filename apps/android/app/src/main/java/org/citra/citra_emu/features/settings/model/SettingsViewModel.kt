// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.settings.model

import android.os.Bundle
import androidx.lifecycle.ViewModel
import org.citra.citra_emu.NativeLibrary
import org.citra.citra_emu.features.settings.data.AppSettingsRepository
import org.citra.citra_emu.features.settings.data.EmulatorSettingsRepository
import org.citra.citra_emu.features.settings.data.EmulatorSettingsService
import org.citra.citra_emu.features.settings.ui.SettingsActivityView
import org.citra.citra_emu.utils.DirectoryInitialization
import org.citra.citra_emu.utils.Log
import org.citra.citra_emu.utils.SystemSaveGame

class SettingsViewModel : ViewModel() {
    val settings = Settings()
    val appSettings = AppSettingsRepository()

    private val repository = EmulatorSettingsRepository()
    private val service = EmulatorSettingsService(repository)

    private var shouldSave = false

    /**
     * Loads every emulator setting the settings screen might need, off the UI thread. Called
     * once, before the settings screen shows any section, so no individual section has to load
     * anything (or show its own loading state) itself.
     */
    suspend fun prepareAll(gameId: String?, view: SettingsActivityView?) {
        service.prepareAll(settings, gameId, view)
    }

    fun onPause() {
        SystemSaveGame.save()
    }

    fun onStart() {
        if (!DirectoryInitialization.areCitraDirectoriesReady()) {
            DirectoryInitialization.start()
        }
    }

    /**
     * Persists settings to disk when the settings screen is finishing with unsaved changes, and
     * restarts the app if a pending display language change needs to be applied.
     */
    fun onStop(finishing: Boolean, activityView: SettingsActivityView) {
        if (finishing && shouldSave) {
            Log.debug("[SettingsActivity] Settings activity stopping. Saving settings to INI...")
            settings.saveSettings(activityView)
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

    fun restoreState(savedInstanceState: Bundle?) {
        if (savedInstanceState != null) {
            shouldSave = savedInstanceState.getBoolean(KEY_SHOULD_SAVE)
        }
    }

    companion object {
        private const val KEY_SHOULD_SAVE = "should_save"
    }
}
