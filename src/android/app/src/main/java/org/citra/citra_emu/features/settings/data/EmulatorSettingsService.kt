// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.settings.data

import org.citra.citra_emu.features.settings.model.Settings
import org.citra.citra_emu.features.settings.ui.SettingsActivityView

/**
 * Decides what [EmulatorSettingsRepository] data needs to be loaded before a given settings
 * section can be displayed, and loads it. The ini-backed settings are always required; the
 * native system save data ([org.citra.citra_emu.utils.SystemSaveGame]) is only required for the
 * "System"/"Audio" sections, matching what [org.citra.citra_emu.features.settings.ui.SettingsFragmentPresenter]
 * reads to build those sections' items.
 */
class EmulatorSettingsService(private val repository: EmulatorSettingsRepository) {
    private var systemSaveGameLoaded = false

    suspend fun prepareSection(menuTag: String, settings: Settings, gameId: String?, view: SettingsActivityView?) {
        if (!settings.isLoaded) {
            repository.loadIniSettings(settings, gameId, view)
        }
        if (!systemSaveGameLoaded &&
            (menuTag == Settings.SECTION_SYSTEM || menuTag == Settings.SECTION_AUDIO)
        ) {
            repository.loadSystemSaveGame()
            systemSaveGameLoaded = true
        }
    }
}
