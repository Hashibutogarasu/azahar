// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.repository

import org.citra.citra_emu.features.settings.data.PreferenceStore
import org.citra.citra_emu.features.settings.data.SharedPreferencesStore
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.utils.GameHelper

/**
 * Single source of truth for the installed/discovered game list and which of those games are
 * visible to the user. Owns the "show HOME menu / system apps" filter setting end to end: it is
 * the only place that knows which preference key controls this filter and that
 * [Game.isSystemTitle] is the field to filter on — [PreferenceStore] itself is a plain key-value
 * store with no notion of games or filters.
 */
class GamesRepository(private val preferenceStore: PreferenceStore = SharedPreferencesStore()) {
    companion object {
        private const val KEY_SHOW_HOME_APPS = "ShowHomeApps"
    }

    /** Scans disk/JNI for all games, installed or not. Does heavy I/O; call off the main thread. */
    fun getAllGames(): List<Game> = GameHelper.getGames()

    /** Applies the current "show HOME menu / system apps" setting to [games]. */
    fun filterVisibleGames(games: List<Game>): List<Game> =
        if (isShowHomeAppsEnabled()) games else games.filter { !it.isSystemTitle }

    fun isShowHomeAppsEnabled(): Boolean = preferenceStore.getBoolean(KEY_SHOW_HOME_APPS, false)

    fun setShowHomeAppsEnabled(enabled: Boolean) {
        preferenceStore.putBoolean(KEY_SHOW_HOME_APPS, enabled)
    }
}
