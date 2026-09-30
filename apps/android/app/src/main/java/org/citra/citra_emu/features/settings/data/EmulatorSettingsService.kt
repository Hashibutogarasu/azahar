// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.settings.data

import org.citra.citra_emu.features.settings.model.Settings
import org.citra.citra_emu.features.settings.ui.SettingsActivityView

/**
 * Loads everything [org.citra.citra_emu.features.settings.ui.SettingsSectionViewModel] needs to
 * build any settings section's items, once, up front. The settings screen awaits this before
 * showing any section, so individual sections never have to load anything themselves.
 */
class EmulatorSettingsService(private val repository: EmulatorSettingsRepository) {
    private var systemSaveGameLoaded = false

    suspend fun prepareAll(settings: Settings, gameId: String?, view: SettingsActivityView?) {
        if (!settings.isLoaded) {
            repository.loadIniSettings(settings, gameId, view)
        }
        if (!systemSaveGameLoaded) {
            repository.loadSystemSaveGame()
            systemSaveGameLoaded = true
        }
    }
}
