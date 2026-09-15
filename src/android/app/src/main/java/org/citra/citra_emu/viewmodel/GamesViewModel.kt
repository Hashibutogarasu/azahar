// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.viewmodel

import android.net.Uri
import androidx.documentfile.provider.DocumentFile
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.preference.PreferenceManager
import java.util.Locale
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.repository.GamesRepository
import org.citra.citra_emu.utils.GameHelper

class GamesViewModel(private val gamesRepository: GamesRepository = GamesRepository()) : ViewModel() {
    val games get() = _games.asStateFlow()
    private val _games = MutableStateFlow(emptyList<Game>())
    private var allGames = emptyList<Game>()

    val isReloading get() = _isReloading.asStateFlow()
    private val _isReloading = MutableStateFlow(false)

    val shouldScrollToTop get() = _shouldScrollToTop.asStateFlow()
    private val _shouldScrollToTop = MutableStateFlow(false)

    val showHomeApps get() = _showHomeApps.asStateFlow()
    private val _showHomeApps = MutableStateFlow(gamesRepository.isShowHomeAppsEnabled())

    private val preferences =
        PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)

    init {
        // Retrieve list of cached games
        val storedGames = preferences.getStringSet(GameHelper.KEY_GAMES, emptySet())
        if (storedGames!!.isNotEmpty()) {
            val deserializedGames = mutableSetOf<Game>()
            storedGames.forEach {
                val game: Game
                try {
                    game = Json.decodeFromString(it)
                } catch (ignored: Exception) {
                    return@forEach
                }

                val gameExists =
                    DocumentFile.fromSingleUri(CitraApplication.appContext, Uri.parse(game.path))
                        ?.exists()
                if (gameExists == true) {
                    deserializedGames.add(game)
                } else if (game.isInstalled) {
                    deserializedGames.add(game)
                }
            }
            setGames(deserializedGames.toList())
        }
        reloadGames()
    }

    fun setGames(games: List<Game>) {
        allGames = games.sortedWith(
            compareBy(
                { it.title.lowercase(Locale.getDefault()) },
                { it.path }
            )
        )
        _games.value = gamesRepository.filterVisibleGames(allGames)
    }

    fun setShouldScrollToTop(shouldScroll: Boolean) {
        _shouldScrollToTop.value = shouldScroll
    }

    fun setShowHomeApps(enabled: Boolean) {
        gamesRepository.setShowHomeAppsEnabled(enabled)
        _showHomeApps.value = enabled
        _games.value = gamesRepository.filterVisibleGames(allGames)
    }

    /**
     * Re-reads the "show HOME menu apps" preference and the game list from disk.
     *
     * Screens that mutate this state (e.g. the System Files screen's toggle) may now run in a
     * separate Activity with their own [GamesViewModel] instance, so this instance's in-memory
     * state can go stale while such a screen is open. Call this when returning to the home
     * screen to pick up any changes made elsewhere.
     */
    fun refresh() {
        _showHomeApps.value = gamesRepository.isShowHomeAppsEnabled()
        reloadGames()
    }

    fun reloadGames() {
        if (isReloading.value) {
            return
        }
        _isReloading.value = true

        viewModelScope.launch {
            withContext(Dispatchers.IO) {
                setGames(gamesRepository.getAllGames())
                _isReloading.value = false
            }
        }
    }
}
