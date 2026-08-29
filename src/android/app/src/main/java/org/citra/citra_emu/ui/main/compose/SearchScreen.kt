// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.main.compose

import android.content.SharedPreferences
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.FilterChip
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.res.integerResource
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootGraph
import com.ramcosta.composedestinations.generated.destinations.CheatsRouteDestination
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import info.debatty.java.stringsimilarity.Jaccard
import info.debatty.java.stringsimilarity.JaroWinkler
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.R
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.utils.GameIconUtils
import org.citra.citra_emu.viewmodel.GamesViewModel
import org.citra.citra_emu.viewmodel.HomeViewModel
import androidx.preference.PreferenceManager
import java.time.temporal.ChronoField
import java.util.Locale

private enum class SearchFilter { NONE, RECENTLY_PLAYED, RECENTLY_ADDED, INSTALLED }

/**
 * Search and filter tab. Mirrors the legacy `SearchFragment`; reuses [GameCard] from
 * [GamesScreen] for result rendering.
 */
@Destination<RootGraph>
@Composable
fun SearchScreen(
    navigator: DestinationsNavigator,
    gamesViewModel: GamesViewModel,
    homeViewModel: HomeViewModel,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val onGameClick: (Game) -> Unit = { game -> context.startActivity(game.launchIntent) }
    val onCheatsClick: (Game) -> Unit = { game ->
        navigator.navigate(CheatsRouteDestination(titleId = game.titleId))
    }

    LaunchedEffect(Unit) {
        homeViewModel.setNavigationVisibility(visible = true, animated = true)
        homeViewModel.setStatusBarShadeVisibility(visible = true)
    }

    val games by gamesViewModel.games.collectAsStateWithLifecycle()
    val searchFocusRequested by gamesViewModel.searchFocused.collectAsStateWithLifecycle()

    var query by rememberSaveable { mutableStateOf("") }
    var filter by rememberSaveable { mutableStateOf(SearchFilter.NONE) }
    val focusRequester = remember { FocusRequester() }
    val keyboardController = LocalSoftwareKeyboardController.current
    val preferences = remember {
        PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
    }

    LaunchedEffect(searchFocusRequested) {
        if (searchFocusRequested) {
            focusRequester.requestFocus()
            keyboardController?.show()
            gamesViewModel.setSearchFocused(false)
        }
    }

    val results = remember(games, query, filter) {
        filterAndSearch(games, query, filter, preferences)
    }

    Column(modifier.fillMaxSize()) {
        SearchField(
            query = query,
            onQueryChange = { query = it },
            focusRequester = focusRequester,
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 20.dp, vertical = 12.dp)
        )

        Row(
            Modifier
                .fillMaxWidth()
                .padding(horizontal = 20.dp, vertical = 4.dp),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            FilterChip(
                selected = filter == SearchFilter.RECENTLY_PLAYED,
                onClick = {
                    filter = if (filter == SearchFilter.RECENTLY_PLAYED) SearchFilter.NONE else SearchFilter.RECENTLY_PLAYED
                },
                label = { Text(stringResource(R.string.search_recently_played)) }
            )
            FilterChip(
                selected = filter == SearchFilter.RECENTLY_ADDED,
                onClick = {
                    filter = if (filter == SearchFilter.RECENTLY_ADDED) SearchFilter.NONE else SearchFilter.RECENTLY_ADDED
                },
                label = { Text(stringResource(R.string.search_recently_added)) }
            )
            FilterChip(
                selected = filter == SearchFilter.INSTALLED,
                onClick = {
                    filter = if (filter == SearchFilter.INSTALLED) SearchFilter.NONE else SearchFilter.INSTALLED
                },
                label = { Text(stringResource(R.string.search_installed)) }
            )
        }

        Box(Modifier.fillMaxSize()) {
            if (results.isEmpty()) {
                Column(
                    Modifier
                        .fillMaxSize()
                        .padding(24.dp),
                    verticalArrangement = Arrangement.Center,
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Icon(
                        painterResource(R.drawable.ic_search),
                        contentDescription = null,
                        modifier = Modifier.size(80.dp)
                    )
                    Text(
                        stringResource(R.string.search_and_filter_games),
                        style = MaterialTheme.typography.titleLarge,
                        textAlign = TextAlign.Center
                    )
                }
            } else {
                val iconLoader = GameIconUtils.rememberGameIconLoader()
                LazyVerticalGrid(
                    columns = GridCells.Fixed(integerResource(R.integer.game_grid_columns)),
                    modifier = Modifier.fillMaxSize(),
                    contentPadding = PaddingValues(8.dp)
                ) {
                    items(results, key = { it.titleId to it.path }) { game ->
                        GameCard(
                            game = game,
                            iconLoader = iconLoader,
                            onClick = { onGameClick(game) },
                            onLongClick = { onCheatsClick(game) }
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun SearchField(
    query: String,
    onQueryChange: (String) -> Unit,
    focusRequester: FocusRequester,
    modifier: Modifier = Modifier
) {
    Card(
        shape = RoundedCornerShape(28.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant),
        modifier = modifier
    ) {
        Row(
            Modifier
                .fillMaxWidth()
                .padding(horizontal = 8.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                painterResource(R.drawable.ic_search),
                contentDescription = null,
                modifier = Modifier
                    .padding(start = 16.dp, end = 16.dp)
                    .size(28.dp)
            )
            OutlinedTextField(
                value = query,
                onValueChange = onQueryChange,
                placeholder = { Text(stringResource(R.string.home_search_games)) },
                singleLine = true,
                modifier = Modifier
                    .weight(1f)
                    .focusRequester(focusRequester)
            )
            if (query.isNotEmpty()) {
                IconButton(onClick = { onQueryChange("") }) {
                    Icon(painterResource(R.drawable.ic_clear), contentDescription = null)
                }
            }
        }
    }
}

private fun filterAndSearch(
    games: List<Game>,
    query: String,
    filter: SearchFilter,
    preferences: SharedPreferences
): List<Game> {
    if (query.isEmpty() && filter == SearchFilter.NONE) {
        return emptyList()
    }

    val filtered: List<Game> = when (filter) {
        SearchFilter.RECENTLY_PLAYED -> games.filter {
            val lastPlayedTime = preferences.getLong(it.keyLastPlayedTime, 0L)
            lastPlayedTime > (System.currentTimeMillis() - ChronoField.MILLI_OF_DAY.range().maximum)
        }
        SearchFilter.RECENTLY_ADDED -> games.filter {
            val addedTime = preferences.getLong(it.keyAddedToLibraryTime, 0L)
            addedTime > (System.currentTimeMillis() - ChronoField.MILLI_OF_DAY.range().maximum)
        }
        SearchFilter.INSTALLED -> games.filter { it.isInstalled }
        SearchFilter.NONE -> games
    }

    if (query.isEmpty()) {
        return filtered
    }

    val searchTerm = query.lowercase(Locale.getDefault())
    val searchAlgorithm = if (searchTerm.length > 1) Jaccard(2) else JaroWinkler()
    return filtered.mapNotNull { game ->
        val title = game.title.lowercase(Locale.getDefault())
        val score = searchAlgorithm.similarity(searchTerm, title)
        if (score > 0.03) score to game else null
    }.sortedByDescending { it.first }.map { it.second }
}
