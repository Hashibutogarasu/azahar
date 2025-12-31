package org.citra.citra_emu.viewmodel
import android.net.Uri
import androidx.documentfile.provider.DocumentFile
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.preference.PreferenceManager
import java.util.Locale
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.utils.GameHelper
class GamesViewModel : ViewModel() {
    private val keyHiddenGames = "hidden_games"
    private val sharedPreferences = PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
    private val _games = MutableStateFlow(emptyList<Game>())
    private val _hiddenGameIds = MutableStateFlow(
        sharedPreferences.getStringSet(keyHiddenGames, emptySet()) ?: emptySet()
    )
    private val _searchQuery = MutableStateFlow("")
    val searchQuery = _searchQuery.asStateFlow()
    val games = combine(_games, _hiddenGameIds, _searchQuery) { games, hiddenIds, query ->
        games.filter {
            !hiddenIds.contains(it.path) &&
                (query.isEmpty() || it.title.contains(query, ignoreCase = true))
        }
    }.stateIn(viewModelScope, SharingStarted.Lazily, emptyList())
    val hiddenGames = combine(_games, _hiddenGameIds, _searchQuery) { games, hiddenIds, query ->
        games.filter {
            hiddenIds.contains(it.path) &&
                (query.isEmpty() || it.title.contains(query, ignoreCase = true))
        }
    }.stateIn(viewModelScope, SharingStarted.Lazily, emptyList())
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
    init {
        // Retrieve list of cached games
        val storedGames = PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
            .getStringSet(GameHelper.KEY_GAMES, emptySet())
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
    fun setSearchQuery(query: String) {
        _searchQuery.value = query
    }
    fun toggleGameHidden(game: Game) {
        val current = _hiddenGameIds.value.toMutableSet()
        if (current.contains(game.path)) {
            current.remove(game.path)
        } else {
            current.add(game.path)
        }
        _hiddenGameIds.value = current
        sharedPreferences.edit().putStringSet(keyHiddenGames, current).apply()
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
}
