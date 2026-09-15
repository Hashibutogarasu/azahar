// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.viewmodel

import android.net.Uri
import android.view.View
import androidx.documentfile.provider.DocumentFile
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.preference.PreferenceManager
import info.debatty.java.stringsimilarity.Jaccard
import info.debatty.java.stringsimilarity.JaroWinkler
import java.time.temporal.ChronoField
import java.util.Locale
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.R
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.utils.GameHelper

class GamesViewModel : ViewModel() {
    val games get() = _games.asStateFlow()
    private val _games = MutableStateFlow(emptyList<Game>())

    val searchedGames get() = _searchedGames.asStateFlow()
    private val _searchedGames = MutableStateFlow(emptyList<Game>())

    val isReloading get() = _isReloading.asStateFlow()
    private val _isReloading = MutableStateFlow(false)

    val shouldSwapData get() = _shouldSwapData.asStateFlow()
    private val _shouldSwapData = MutableStateFlow(false)

    val shouldScrollToTop get() = _shouldScrollToTop.asStateFlow()
    private val _shouldScrollToTop = MutableStateFlow(false)

    val searchFocused get() = _searchFocused.asStateFlow()
    private val _searchFocused = MutableStateFlow(false)

    private val preferences =
        PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)

    private class ScoredGame(val score: Double, val item: Game)

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
        reloadGames(false)
    }

    fun setGames(games: List<Game>) {
        val sortedList = games.sortedWith(
            compareBy(
                { it.title.lowercase(Locale.getDefault()) },
                { it.path }
            )
        )
        val filteredList = sortedList.filter {
            if (it.isSystemTitle) {
                it.isVisibleSystemTitle
            }
            true
        }

        _games.value = filteredList
    }

    fun setSearchedGames(games: List<Game>) {
        _searchedGames.value = games
    }

    fun setShouldSwapData(shouldSwap: Boolean) {
        _shouldSwapData.value = shouldSwap
    }

    fun setShouldScrollToTop(shouldScroll: Boolean) {
        _shouldScrollToTop.value = shouldScroll
    }

    fun setSearchFocused(searchFocused: Boolean) {
        _searchFocused.value = searchFocused
    }

    fun reloadGames(directoryChanged: Boolean) {
        if (isReloading.value) {
            return
        }
        _isReloading.value = true

        viewModelScope.launch {
            withContext(Dispatchers.IO) {
                setGames(GameHelper.getGames())
                _isReloading.value = false

                if (directoryChanged) {
                    setShouldSwapData(true)
                }
            }
        }
    }

    /**
     * Filters [games] by [selectedChipId] (recently played/added, installed) and, when
     * [searchTerm] is non-empty, ranks the result by title similarity (Jaccard for multi-char
     * terms, JaroWinkler otherwise), then publishes the result via [searchedGames].
     */
    fun filterAndSearch(searchTerm: String, selectedChipId: Int) {
        if (searchTerm.isEmpty() && selectedChipId == View.NO_ID) {
            setSearchedGames(emptyList())
            return
        }

        val baseList = games.value
        val filteredList: List<Game> = when (selectedChipId) {
            R.id.chip_recently_played -> {
                baseList.filter {
                    val lastPlayedTime = preferences.getLong(it.keyLastPlayedTime, 0L)
                    lastPlayedTime > (System.currentTimeMillis() - ChronoField.MILLI_OF_DAY.range().maximum)
                }
            }

            R.id.chip_recently_added -> {
                baseList.filter {
                    val addedTime = preferences.getLong(it.keyAddedToLibraryTime, 0L)
                    addedTime > (System.currentTimeMillis() - ChronoField.MILLI_OF_DAY.range().maximum)
                }
            }

            R.id.chip_installed -> baseList.filter { it.isInstalled }

            else -> baseList
        }

        if (searchTerm.isEmpty() && selectedChipId != View.NO_ID) {
            setSearchedGames(filteredList)
            return
        }

        val lowerSearchTerm = searchTerm.lowercase(Locale.getDefault())
        val searchAlgorithm = if (lowerSearchTerm.length > 1) Jaccard(2) else JaroWinkler()
        val sortedList: List<Game> = filteredList.mapNotNull { game ->
            val title = game.title.lowercase(Locale.getDefault())
            val score = searchAlgorithm.similarity(lowerSearchTerm, title)
            if (score > 0.03) {
                ScoredGame(score, game)
            } else {
                null
            }
        }.sortedByDescending { it.score }.map { it.item }
        setSearchedGames(sortedList)
    }
}
