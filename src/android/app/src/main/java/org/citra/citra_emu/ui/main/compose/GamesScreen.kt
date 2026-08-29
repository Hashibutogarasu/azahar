// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.main.compose

import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.graphics.drawable.Icon
import android.net.Uri
import android.os.SystemClock
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon as M3Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.pulltorefresh.PullToRefreshBox
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableLongStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.integerResource
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.core.text.HtmlCompat
import androidx.documentfile.provider.DocumentFile
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.preference.PreferenceManager
import coil.ImageLoader
import coil.compose.AsyncImage
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.R
import org.citra.citra_emu.features.settings.model.Settings
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.utils.GameIconUtils
import org.citra.citra_emu.viewmodel.GamesViewModel
import org.citra.citra_emu.viewmodel.HomeViewModel

/**
 * The default home tab: a grid of installed/discovered games. Mirrors the legacy
 * `GamesFragment` + `GameAdapter`.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GamesScreen(
    gamesViewModel: GamesViewModel,
    homeViewModel: HomeViewModel,
    onGameClick: (Game) -> Unit,
    onCheatsClick: (Game) -> Unit,
    modifier: Modifier = Modifier
) {
    val allGames by gamesViewModel.games.collectAsStateWithLifecycle()
    val isReloading by gamesViewModel.isReloading.collectAsStateWithLifecycle()
    val shouldSwapData by gamesViewModel.shouldSwapData.collectAsStateWithLifecycle()

    LaunchedEffect(Unit) {
        homeViewModel.setNavigationVisibility(visible = true, animated = true)
        homeViewModel.setStatusBarShadeVisibility(visible = true)
    }

    var showHomeApps by remember {
        mutableStateOf(
            PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
                .getBoolean(Settings.PREF_SHOW_HOME_APPS, false)
        )
    }
    LaunchedEffect(shouldSwapData) {
        if (shouldSwapData) {
            showHomeApps = PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
                .getBoolean(Settings.PREF_SHOW_HOME_APPS, false)
            gamesViewModel.setShouldSwapData(false)
        }
    }
    val games = remember(allGames, showHomeApps) {
        if (showHomeApps) allGames else allGames.filter { !it.isSystemTitle }
    }

    var show3DSFileWarning by rememberSaveable { mutableStateOf(true) }

    Box(modifier.fillMaxSize()) {
        PullToRefreshBox(
            isRefreshing = isReloading,
            onRefresh = { gamesViewModel.reloadGames(false) },
            modifier = Modifier.fillMaxSize()
        ) {
            if (games.isEmpty() && !isReloading) {
                Text(
                    stringResource(R.string.empty_gamelist),
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(24.dp),
                    textAlign = TextAlign.Center
                )
            } else {
                GameGrid(games = games, onGameClick = onGameClick, onCheatsClick = onCheatsClick)
            }
        }
    }

    if (show3DSFileWarning &&
        !PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
            .getBoolean("show_3ds_files_warning", false)
    ) {
        Warning3DSFilesDialog(onDismiss = {
            show3DSFileWarning = false
            PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
                .edit().putBoolean("show_3ds_files_warning", true).apply()
        })
    }
}

@Composable
private fun Warning3DSFilesDialog(onDismiss: () -> Unit) {
    val context = LocalContext.current
    val message = remember {
        HtmlCompat.fromHtml(
            context.getString(R.string.warning_3ds_files),
            HtmlCompat.FROM_HTML_MODE_LEGACY
        ).toString()
    }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.important)) },
        text = { Text(message) },
        confirmButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.dont_show_again)) }
        }
    )
}

@Composable
private fun GameGrid(
    games: List<Game>,
    onGameClick: (Game) -> Unit,
    onCheatsClick: (Game) -> Unit,
    modifier: Modifier = Modifier
) {
    val iconLoader = GameIconUtils.rememberGameIconLoader()
    var lastClickTime by remember { mutableLongStateOf(0L) }
    var aboutGame by remember { mutableStateOf<Game?>(null) }
    var notLoadedGame by remember { mutableStateOf(false) }

    LazyVerticalGrid(
        columns = GridCells.Fixed(integerResource(R.integer.game_grid_columns)),
        modifier = modifier.fillMaxSize(),
        contentPadding = PaddingValues(8.dp)
    ) {
        items(games, key = { it.titleId to it.path }) { game ->
            GameCard(
                game = game,
                iconLoader = iconLoader,
                onClick = {
                    if (SystemClock.elapsedRealtime() - lastClickTime >= 1000) {
                        lastClickTime = SystemClock.elapsedRealtime()
                        if (gameStillExists(game)) onGameClick(game)
                    }
                },
                onLongClick = {
                    if (gameStillExists(game)) {
                        if (game.titleId == 0L) notLoadedGame = true else aboutGame = game
                    }
                }
            )
        }
    }

    if (notLoadedGame) {
        AlertDialog(
            onDismissRequest = { notLoadedGame = false },
            title = { Text(stringResource(R.string.properties)) },
            text = { Text(stringResource(R.string.properties_not_loaded)) },
            confirmButton = {
                TextButton(onClick = { notLoadedGame = false }) { Text(stringResource(android.R.string.ok)) }
            }
        )
    }

    aboutGame?.let { game ->
        AboutGameBottomSheet(
            game = game,
            iconLoader = iconLoader,
            onDismiss = { aboutGame = null },
            onPlay = {
                aboutGame = null
                onGameClick(game)
            },
            onCheats = {
                aboutGame = null
                onCheatsClick(game)
            }
        )
    }
}

/** Triggers a library refresh if the user interacts with stale data, mirroring `gameExists`. */
private fun gameStillExists(game: Game): Boolean {
    if (game.isInstalled) return true
    return DocumentFile.fromSingleUri(CitraApplication.appContext, Uri.parse(game.path))?.exists() == true
}

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun GameCard(
    game: Game,
    iconLoader: ImageLoader,
    onClick: () -> Unit,
    onLongClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val isValid = remember(game.filename) {
        val extension = game.filename.substringAfterLast('.', "").lowercase()
        Game.badExtensions.none { extension == it.lowercase() }
    }
    OutlinedCard(
        colors = if (isValid) {
            CardDefaults.outlinedCardColors()
        } else {
            CardDefaults.outlinedCardColors(containerColor = MaterialTheme.colorScheme.errorContainer)
        },
        modifier = modifier
            .padding(8.dp)
            .combinedClickable(onClick = onClick, onLongClick = onLongClick)
    ) {
        Row(
            Modifier
                .fillMaxWidth()
                .padding(8.dp)
        ) {
            AsyncImage(
                model = GameIconUtils.rememberGameIconRequest(game),
                imageLoader = iconLoader,
                contentDescription = null,
                contentScale = ContentScale.Crop,
                modifier = Modifier.size(75.dp)
            )
            Column(
                Modifier
                    .weight(1f)
                    .padding(start = 8.dp),
                verticalArrangement = Arrangement.Center
            ) {
                if (game.title.isNotEmpty()) {
                    Text(
                        game.title,
                        style = MaterialTheme.typography.bodyMedium,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis
                    )
                }
                if (game.company.isNotEmpty()) {
                    Text(
                        game.company,
                        style = MaterialTheme.typography.bodySmall,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis
                    )
                }
                Text(
                    game.regions,
                    style = MaterialTheme.typography.bodySmall,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun AboutGameBottomSheet(
    game: Game,
    iconLoader: ImageLoader,
    onDismiss: () -> Unit,
    onPlay: () -> Unit,
    onCheats: () -> Unit
) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()
    ModalBottomSheet(onDismissRequest = onDismiss, sheetState = rememberModalBottomSheetState()) {
        Column(Modifier.padding(horizontal = 16.dp, vertical = 8.dp)) {
            Row {
                AsyncImage(
                    model = GameIconUtils.rememberGameIconRequest(game),
                    imageLoader = iconLoader,
                    contentDescription = null,
                    contentScale = ContentScale.Crop,
                    modifier = Modifier
                        .size(140.dp)
                        .clip(RoundedCornerShape(16.dp))
                )
                Column(Modifier.padding(start = 16.dp)) {
                    Text(game.title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                    Text(game.company, style = MaterialTheme.typography.bodyMedium)
                    Text(game.regions, style = MaterialTheme.typography.bodyMedium)
                    Text(
                        "ID: " + String.format("%016X", game.titleId),
                        style = MaterialTheme.typography.bodyMedium
                    )
                    Text("File: " + game.filename, style = MaterialTheme.typography.bodyMedium)
                }
            }
            Spacer(Modifier.height(16.dp))
            Row {
                Button(onClick = onPlay, modifier = Modifier.weight(3f)) {
                    Text(stringResource(R.string.play))
                }
                Spacer(Modifier.width(8.dp))
                IconButton(onClick = {
                    val shortcutManager = context.getSystemService(ShortcutManager::class.java)
                    scope.launch {
                        val icon = withContext(Dispatchers.IO) {
                            GameIconUtils.loadGameIconBitmapBlocking(game)
                        }?.let { Icon.createWithBitmap(it) }
                        val shortcut = ShortcutInfo.Builder(context, game.title)
                            .setShortLabel(game.title)
                            .apply { if (icon != null) setIcon(icon) }
                            .setIntent(game.launchIntent.apply { putExtra("launched_from_shortcut", true) })
                            .build()
                        shortcutManager?.requestPinShortcut(shortcut, null)
                    }
                }) {
                    M3Icon(
                        painterResource(R.drawable.ic_shortcut),
                        contentDescription = stringResource(R.string.shortcut)
                    )
                }
            }
            Spacer(Modifier.height(16.dp))
            Button(onClick = onCheats) { Text(stringResource(R.string.cheats)) }
        }
    }
}
