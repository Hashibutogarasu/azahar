package org.citra.citra_emu.ui.components

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.pulltorefresh.PullToRefreshBox
import androidx.compose.material3.pulltorefresh.rememberPullToRefreshState
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
 * Full Compose implementation of the games list screen.
 * Replaces the XML-based GamesFragment layout.
 *
 * @param viewModel The GamesViewModel
 * @param onOpenDrawer Called when the drawer should be opened
 * @param onGameSelected Called when a game is selected for playing
 * @param onOpenFolders Called when user wants to open game folders
 * @param onUninstall Called when user wants to uninstall game content
 * @param onShortcut Called when user wants to create a shortcut
 * @param onCheats Called when user wants to open cheats
 * @param modifier Modifier for the screen
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GamesScreen(
    viewModel: GamesViewModel,
    onOpenDrawer: () -> Unit,
    onGameSelected: (Game) -> Unit,
    onOpenFolders: (Game) -> Unit,
    onUninstall: (Game) -> Unit,
    onShortcut: (Game) -> Unit,
    onCheats: (Game) -> Unit,
    modifier: Modifier = Modifier
) {
    val games by viewModel.games.collectAsState()
    val isReloading by viewModel.isReloading.collectAsState()
    val searchQuery by viewModel.searchQuery.collectAsState()
    var selectedGame by remember { mutableStateOf<Game?>(null) }
    val sheetState = rememberModalBottomSheetState()
    val scope = rememberCoroutineScope()
    val pullToRefreshState = rememberPullToRefreshState()
    // Filter games based on search query
    val filteredGames = remember(games, searchQuery) {
        if (searchQuery.isBlank()) {
            games
        } else {
            games.filter { game ->
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
                modifier = Modifier
            )
        },
        modifier = modifier
    ) { paddingValues ->
        PullToRefreshBox(
            isRefreshing = isReloading,
            onRefresh = { viewModel.reloadGames(false) },
            state = pullToRefreshState,
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
        ) {
            if (filteredGames.isEmpty() && !isReloading) {
                // Empty state
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = stringResource(R.string.empty_gamelist),
                        style = MaterialTheme.typography.bodyLarge,
                        color = MaterialTheme.colorScheme.onSurface
                    )
                }
            } else {
                // Games list
                LazyColumn(
                    contentPadding = PaddingValues(vertical = 4.dp),
                    modifier = Modifier.fillMaxSize()
                ) {
                    items(
                        items = filteredGames,
                        key = { it.path }
                    ) { game ->
                        GameListTile(
                            game = game,
                            onClick = { onGameSelected(game) },
                            onLongClick = { selectedGame = game }
                        )
                    }
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
                isHidden = false,
                onPlay = {
                    scope.launch { sheetState.hide() }
                    selectedGame = null
                    onGameSelected(game)
                },
                onOpenMenu = {
                    scope.launch { sheetState.hide() }
                    selectedGame = null
                    onOpenFolders(game)
                },
                onUninstallMenu = {
                    scope.launch { sheetState.hide() }
                    selectedGame = null
                    onUninstall(game)
                },
                onShortcut = {
                    scope.launch { sheetState.hide() }
                    selectedGame = null
                    onShortcut(game)
                },
                onCheats = {
                    scope.launch { sheetState.hide() }
                    selectedGame = null
                    onCheats(game)
                },
                onToggleVisibility = {
                    viewModel.toggleGameHidden(game)
                    scope.launch { sheetState.hide() }
                    selectedGame = null
                }
            )
        }
    }
}
