// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.profiles

import android.content.Context
import android.net.Uri
import org.json.JSONArray
import org.json.JSONObject

/**
 * The profiles that [ProfilesDocumentsProvider] serves, as last handed over by Dart.
 *
 * They are kept in shared preferences because the provider can be queried while the app is not
 * running.
 */
internal class ProfileStore(context: Context) {
    data class Entry(
        val hash: String,
        val name: String,
        val isBuiltIn: Boolean,
        val location: Uri
    )

    private val preferences =
        context.getSharedPreferences("azahar_for_flutter_profiles", Context.MODE_PRIVATE)

    fun entries(): List<Entry> {
        val json = preferences.getString(KEY_PROFILES, null) ?: return emptyList()
        val array = JSONArray(json)
        return (0 until array.length()).map { index ->
            val item = array.getJSONObject(index)
            Entry(
                hash = item.getString("hash"),
                name = item.getString("name"),
                isBuiltIn = item.getBoolean("isBuiltIn"),
                location = Uri.parse(item.getString("location"))
            )
        }
    }

    fun entry(hash: String): Entry? = entries().firstOrNull { it.hash == hash }

    fun replace(entries: List<Entry>) {
        val array = JSONArray()
        entries.forEach { entry ->
            array.put(
                JSONObject()
                    .put("hash", entry.hash)
                    .put("name", entry.name)
                    .put("isBuiltIn", entry.isBuiltIn)
                    .put("location", entry.location.toString())
            )
        }
        preferences.edit().putString(KEY_PROFILES, array.toString()).apply()
    }

    private companion object {
        const val KEY_PROFILES = "profiles"
    }
}
