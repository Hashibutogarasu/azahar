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
     * Ensures the emulator settings needed to display [menuTag] are loaded, off the UI thread.
     * Callers drive their own loading indicator around this suspend call (e.g. from a
     * `LaunchedEffect` scoped to that section's own screen), since sections can be prepared
     * concurrently and each needs its own independent loading state.
     */
    suspend fun prepareSection(menuTag: String, gameId: String?, view: SettingsActivityView?) {
        service.prepareSection(menuTag, settings, gameId, view)
    }
}
