// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.settings.data

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.citra.citra_emu.features.settings.model.Settings
import org.citra.citra_emu.features.settings.ui.SettingsActivityView
import org.citra.citra_emu.utils.SystemSaveGame

/**
 * Raw data-access layer for the 3DS emulator core's own settings: the ini-backed
 * [Settings]/[org.citra.citra_emu.features.settings.utils.SettingsFile] configuration, and the
 * native [SystemSaveGame] system save data (username, birthday, MAC address, etc.). Every call
 * runs on [Dispatchers.IO], since both are blocking I/O (SAF file access) or JNI calls into the
 * emulator core.
 */
class EmulatorSettingsRepository {
    /**
     * Loads the ini-backed settings into [settings] in place, preserving the single persistent
     * [Settings] instance the rest of the settings screen already holds a reference to.
     */
    suspend fun loadIniSettings(settings: Settings, gameId: String?, view: SettingsActivityView?) =
        withContext(Dispatchers.IO) {
            if (gameId.isNullOrEmpty()) {
                settings.loadSettings(view)
            } else {
                settings.loadSettings(gameId, view!!)
            }
        }

    suspend fun loadSystemSaveGame() = withContext(Dispatchers.IO) {
        SystemSaveGame.load()
    }
}
