// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.settings.data

import android.content.Context
import androidx.appcompat.app.AppCompatDelegate
import androidx.core.os.LocaleListCompat

/**
 * Single source of truth for the Azahar app's own settings, as opposed to
 * [EmulatorSettingsRepository], which owns the 3DS emulator core's settings. Currently covers
 * the app's display language, backed by [AppCompatDelegate]'s per-app language API (itself
 * backed by the OS's `LocaleManager` on API 33+, so this repository and the OS's own
 * "App info > Language" screen always read and write the same underlying state).
 *
 * A language selection made via [selectPendingLanguage] is held only in memory until
 * [applyPendingLanguage] is called (the settings screen defers that to leaving the Language
 * page), so that navigating away and back to the Language page before then still reflects the
 * in-progress choice.
 */
class AppSettingsRepository {
    private var pendingLanguageTag: String? = null

    /** The language tag actually applied via [AppCompatDelegate], or "" for "system default". */
    fun getCurrentLanguageTag(): String = AppCompatDelegate.getApplicationLocales().toLanguageTags()

    /** The in-progress language selection if one hasn't been applied yet, otherwise the applied one. */
    fun getPendingOrCurrentLanguageTag(): String = pendingLanguageTag ?: getCurrentLanguageTag()

    fun selectPendingLanguage(localeTag: String) {
        pendingLanguageTag = localeTag
    }

    /** Applies the pending language selection, if any, via [AppCompatDelegate]. Returns whether
     *  there was one to apply. */
    fun applyPendingLanguage(): Boolean {
        val tag = pendingLanguageTag ?: return false
        pendingLanguageTag = null
        AppCompatDelegate.setApplicationLocales(
            if (tag.isEmpty()) {
                LocaleListCompat.getEmptyLocaleList()
            } else {
                LocaleListCompat.forLanguageTags(tag)
            }
        )
        return true
    }

    /**
     * The language tags this build actually ships translations for, read directly from the
     * compiled resource table via [android.content.res.AssetManager.getLocales] — i.e. exactly
     * the `res/values-*` directories present in this build, with no separate hand-maintained
     * list and no dependency on any build-tool-generated resource name.
     */
    fun getSupportedLanguageTags(context: Context): List<String> =
        context.assets.locales.filter { it.isNotEmpty() }
}
