package org.citra.citra_emu.ui.components

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
import org.citra.citra_emu.R
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.viewmodel.GamesViewModel

/**
 * Screen for displaying hidden games.
 * Reuses the GameListTile component for consistent UI.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HiddenAppsScreen(
    viewModel: GamesViewModel,
    onOpenDrawer: () -> Unit,
    modifier: Modifier = Modifier
) {
    val hiddenGames by viewModel.hiddenGames.collectAsState()
    val searchQuery by viewModel.searchQuery.collectAsState()
    var selectedGame by remember { mutableStateOf<Game?>(null) }
    val sheetState = rememberModalBottomSheetState()
    val scope = rememberCoroutineScope()
    // Filter hidden games based on search query
    val filteredHiddenGames = remember(hiddenGames, searchQuery) {
        if (searchQuery.isBlank()) {
            hiddenGames.toList()
        } else {
            hiddenGames.filter { game ->
                game.title.contains(searchQuery, ignoreCase = true) ||
                        game.company.contains(searchQuery, ignoreCase = true)
            }
        }
    }
    Scaffold(
        topBar = {
            MainHeader(
                onOpenDrawer = onOpenDrawer,
                searchQuery = searchQuery,
                onSearchQueryChanged = viewModel::setSearchQuery,
                onSearch = {},
                modifier = Modifier.statusBarsPadding()
            )
        },
        modifier = modifier
    ) { paddingValues ->
        if (filteredHiddenGames.isEmpty()) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = stringResource(R.string.no_hidden_apps_found),
                    style = MaterialTheme.typography.bodyLarge,
                    color = MaterialTheme.colorScheme.onSurface
                )
            }
        } else {
            LazyColumn(
                contentPadding = PaddingValues(vertical = 4.dp),
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues)
            ) {
                items(
                    items = filteredHiddenGames,
                    key = { it.path }
                ) { game ->
                    // Reuse GameListTile component
                    GameListTile(
                        game = game,
                        onClick = { },
                        onLongClick = { selectedGame = game }
                    )
                }
            }
        }
    }
    // Bottom sheet for game details
    selectedGame?.let { game ->
        ModalBottomSheet(
            onDismissRequest = { selectedGame = null },
            sheetState = sheetState
        ) {
            GameDetailsBottomSheet(
                game = game,
                isHidden = true,
                onPlay = {
                    scope.launch { sheetState.hide() }
                    selectedGame = null
                },
                onOpenMenu = { },
                onUninstallMenu = { },
                onShortcut = { },
                onCheats = { },
                onToggleVisibility = {
                    viewModel.toggleGameHidden(game)
                    scope.launch { sheetState.hide() }
                    selectedGame = null
                }
            )
        }
    }
}
