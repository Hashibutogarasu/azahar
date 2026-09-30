// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.settings.data

import android.content.Context
import androidx.preference.PreferenceManager
import org.citra.citra_emu.CitraApplication

/**
 * Generic typed key-value settings storage. Deliberately has no knowledge of what any given
 * key means or what it is used for — that domain knowledge belongs to whichever repository
 * reads/writes a particular key (e.g. [org.citra.citra_emu.repository.GamesRepository]).
 */
interface PreferenceStore {
    fun getBoolean(key: String, default: Boolean): Boolean
    fun putBoolean(key: String, value: Boolean)
}

/** [PreferenceStore] backed by the app's default [android.content.SharedPreferences]. */
class SharedPreferencesStore(context: Context = CitraApplication.appContext) : PreferenceStore {
    private val preferences = PreferenceManager.getDefaultSharedPreferences(context)

    override fun getBoolean(key: String, default: Boolean): Boolean =
        preferences.getBoolean(key, default)

    override fun putBoolean(key: String, value: Boolean) {
        preferences.edit().putBoolean(key, value).apply()
    }
}
