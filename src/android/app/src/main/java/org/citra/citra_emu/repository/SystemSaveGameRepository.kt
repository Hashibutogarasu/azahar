// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.repository

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.citra.citra_emu.utils.SystemSaveGame

/**
 * Safe access point for the native [SystemSaveGame] JNI object.
 *
 * [SystemSaveGame]'s native backing pointer is only populated once [SystemSaveGame.load] has
 * run; calling any other [SystemSaveGame] function beforehand dereferences a null pointer and
 * crashes the process. This repository owns that ordering guarantee: callers await
 * [ensureLoaded] before touching any accessor, and never need to call [SystemSaveGame] directly.
 */
class SystemSaveGameRepository {
    private var loaded = false

    /**
     * Loads the native system save data on [Dispatchers.IO] if it has not been loaded yet.
     * Safe to call from every screen that needs [SystemSaveGame] data; repeated calls after the
     * first are no-ops.
     */
    suspend fun ensureLoaded() {
        if (loaded) return
        withContext(Dispatchers.IO) {
            SystemSaveGame.load()
        }
        loaded = true
    }

    /**
     * Returns whether the 3DS system setup flow still needs to run.
     * Must only be called after [ensureLoaded] has completed.
     */
    fun isSystemSetupNeeded(): Boolean = SystemSaveGame.getIsSystemSetupNeeded()

    /**
     * Records whether the 3DS system setup flow still needs to run.
     * Must only be called after [ensureLoaded] has completed.
     */
    fun setSystemSetupNeeded(needed: Boolean) {
        SystemSaveGame.setSystemSetupNeeded(needed)
    }
}
