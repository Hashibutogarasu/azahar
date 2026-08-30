// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.settings.model

import androidx.lifecycle.ViewModel
import org.citra.citra_emu.features.settings.data.AppSettingsRepository
import org.citra.citra_emu.features.settings.data.EmulatorSettingsRepository
import org.citra.citra_emu.features.settings.data.EmulatorSettingsService
import org.citra.citra_emu.features.settings.ui.SettingsActivityView

class SettingsViewModel : ViewModel() {
    val settings = Settings()
    val appSettings = AppSettingsRepository()

    private val repository = EmulatorSettingsRepository()
    private val service = EmulatorSettingsService(repository)

    /**
     * Loads every emulator setting the settings screen might need, off the UI thread. Called
     * once, before the settings screen shows any section, so no individual section has to load
     * anything (or show its own loading state) itself.
     */
    suspend fun prepareAll(gameId: String?, view: SettingsActivityView?) {
        service.prepareAll(settings, gameId, view)
    }
}
