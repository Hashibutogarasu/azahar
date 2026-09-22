// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.main.compose

import android.content.Context
import android.content.Intent
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.graphics.drawable.Icon
import android.net.Uri
import android.os.SystemClock
import android.widget.Toast
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.clickable
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
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon as M3Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
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
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
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
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootGraph
import com.ramcosta.composedestinations.generated.destinations.CheatsRouteDestination
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import info.debatty.java.stringsimilarity.Jaccard
import info.debatty.java.stringsimilarity.JaroWinkler
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File
import java.util.Locale
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.R
import org.citra.citra_emu.activities.EmulationActivity
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.repository.EmulationLaunchRepository
import org.citra.citra_emu.ui.compose.HtmlText
import org.citra.citra_emu.utils.FileUtil
import org.citra.citra_emu.utils.GameIconUtils
import org.citra.citra_emu.utils.Log
import org.citra.citra_emu.viewmodel.GamesViewModel
import org.citra.citra_emu.viewmodel.HomeViewModel

/**
 * The default home tab: a grid of installed/discovered games. Mirrors the legacy
 * `GamesFragment` + `GameAdapter`.
 */
@Destination<RootGraph>(start = true)
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GamesScreen(
    navigator: DestinationsNavigator,
    gamesViewModel: GamesViewModel,
    homeViewModel: HomeViewModel,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val emulationLaunchRepository = remember { EmulationLaunchRepository() }
    val onGameClick: (Game) -> Unit =
        { game -> context.startActivity(emulationLaunchRepository.createLaunchIntent(game)) }
    val onCheatsClick: (Game) -> Unit = { game ->
        navigator.navigate(CheatsRouteDestination(titleId = game.titleId))
    }

    val visibleGames by gamesViewModel.games.collectAsStateWithLifecycle()
    val isReloading by gamesViewModel.isReloading.collectAsStateWithLifecycle()

    LaunchedEffect(Unit) {
        homeViewModel.setNavigationVisibility(visible = true, animated = true)
        homeViewModel.setStatusBarShadeVisibility(visible = true)
    }

    var query by rememberSaveable { mutableStateOf("") }
    val games = remember(visibleGames, query) { searchGames(visibleGames, query) }

    var show3DSFileWarning by rememberSaveable { mutableStateOf(true) }

    Column(modifier.fillMaxSize()) {
        HomeSearchField(
            query = query,
            onQueryChange = { query = it },
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 20.dp, vertical = 12.dp)
        )

        Box(Modifier.fillMaxSize()) {
            PullToRefreshBox(
                isRefreshing = isReloading,
                onRefresh = { gamesViewModel.reloadGames() },
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
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.important)) },
        text = { HtmlText(stringResource(R.string.warning_3ds_files), htmlMode = HtmlCompat.FROM_HTML_MODE_LEGACY) },
        confirmButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.dont_show_again)) }
        }
    )
}

/**
 * Search box shown at the top of [GamesScreen]. Filtering happens in place in the game grid
 * below it — there is no separate search screen or destination to navigate to.
 */
@Composable
private fun HomeSearchField(
    query: String,
    onQueryChange: (String) -> Unit,
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
            M3Icon(
                painterResource(R.drawable.ic_search),
                contentDescription = null,
                modifier = Modifier
                    .padding(start = 16.dp, end = 16.dp)
                    .size(28.dp)
            )
            TextField(
                value = query,
                onValueChange = onQueryChange,
                placeholder = { Text(stringResource(R.string.home_search_games)) },
                singleLine = true,
                colors = TextFieldDefaults.colors(
                    focusedContainerColor = Color.Transparent,
                    unfocusedContainerColor = Color.Transparent,
                    disabledContainerColor = Color.Transparent,
                    focusedIndicatorColor = Color.Transparent,
                    unfocusedIndicatorColor = Color.Transparent,
                    disabledIndicatorColor = Color.Transparent
                ),
                modifier = Modifier.weight(1f)
            )
            if (query.isNotEmpty()) {
                IconButton(onClick = { onQueryChange("") }) {
                    M3Icon(painterResource(R.drawable.ic_clear), contentDescription = null)
                }
            }
        }
    }
}

/**
 * Ranks [games] by title similarity to [query] (Jaccard for multi-char terms, JaroWinkler
 * otherwise); returns [games] unchanged when [query] is empty.
 */
private fun searchGames(games: List<Game>, query: String): List<Game> {
    if (query.isEmpty()) return games

    val searchTerm = query.lowercase(Locale.getDefault())
    val searchAlgorithm = if (searchTerm.length > 1) Jaccard(2) else JaroWinkler()
    return games.mapNotNull { game ->
        val title = game.title.lowercase(Locale.getDefault())
        val score = searchAlgorithm.similarity(searchTerm, title)
        if (score > 0.03) score to game else null
    }.sortedByDescending { it.first }.map { it.second }
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

/**
 * Triggers a library refresh if the user interacts with stale data, mirroring `gameExists`.
 *
 * Native (non-SAF) paths must be checked with [File.exists], not [DocumentFile]: handing a
 * schemeless native path to [DocumentFile.fromSingleUri] makes its `exists()` query a non-content
 * URI, which [android.content.ContentResolver] rejects with an uncaught `IllegalArgumentException`
 * and crashes the app.
 */
private fun gameStillExists(game: Game): Boolean {
    if (game.isInstalled) return true
    val exists = if (FileUtil.isNativePath(game.path)) {
        File(game.path).exists()
    } else {
        DocumentFile.fromSingleUri(CitraApplication.appContext, Uri.parse(game.path))?.exists() == true
    }
    if (!exists) {
        Log.error("[GamesScreen] ROM file does not exist: ${game.path}")
    }
    return exists
}

/**
 * The well-known folders bundled with an installed [Game], mirroring the desktop client's game
 * list context menu (`GameList::AddGamePopup` in `game_list.cpp`). Paths are relative to the
 * Citra user directory's `sdmc/` root, the same convention [Game.path] itself uses for installed
 * titles.
 */
private data class GameDirectories(
    val gameDir: String,
    val saveDir: String,
    val modsDir: String,
    val texturesDir: String,
    val appDir: String,
    val dlcDir: String,
    val updatesDir: String,
    val extraDir: String
)

private fun getGameDirectories(game: Game): GameDirectories {
    val basePath =
        "sdmc/Nintendo 3DS/00000000000000000000000000000000/00000000000000000000000000000000"
    val titleIdHex = String.format("%016x", game.titleId).lowercase()
    return GameDirectories(
        gameDir = game.path.substringBeforeLast("/"),
        saveDir = "$basePath/title/${titleIdHex.substring(0, 8)}/${titleIdHex.substring(8)}" +
            "/data/00000001",
        modsDir = "load/mods/${String.format("%016X", game.titleId)}",
        texturesDir = "load/textures/${String.format("%016X", game.titleId)}",
        appDir = game.path.substringBeforeLast("/").split("/").filter { it.isNotEmpty() }
            .joinToString("/"),
        dlcDir = "$basePath/title/0004008c/${titleIdHex.substring(8)}/content",
        updatesDir = "$basePath/title/0004000e/${titleIdHex.substring(8)}/content",
        extraDir = "$basePath/extdata/00000000/" +
            String.format("%016X", game.titleId).substring(8, 14).padStart(8, '0')
    )
}

/**
 * Deletes the disk shader cache [titleId] has built up for the given graphics [backend], mirroring
 * `NativeLibrary.deleteOpenGLShaderCache`/`deleteVulkanShaderCache` on the file paths those native
 * functions operate on (`FileUtil::UserPath::ShaderDir`, i.e. `shaders/` under the same user
 * directory root [getGameDirectories]'s `sdmc/` paths are already relative to), done through the
 * SAF-backed [org.citra.citra_emu.utils.DocumentsTree] instead of a native call.
 */
private fun deleteShaderCache(titleId: Long, backend: ShaderCacheBackend) {
    val tree = CitraApplication.documentsTree
    val titleIdHex = String.format("%016X", titleId)
    when (backend) {
        ShaderCacheBackend.OPENGL -> {
            listOf("separable", "conventional").forEach { cacheType ->
                tree.deleteDocument("shaders/opengl/precompiled/$cacheType/$titleIdHex.bin")
            }
            tree.deleteDocument("shaders/opengl/transferable/$titleIdHex.bin")
        }

        ShaderCacheBackend.VULKAN -> {
            listOf("vs", "fs", "gs", "pl").forEach { cacheType ->
                tree.deleteDocument("shaders/vulkan/transferable/${titleIdHex}_$cacheType.vkch")
            }
            tree.getFilesName("shaders/vulkan/pipeline")
                .filterNotNull()
                .filter { it.startsWith(titleIdHex) }
                .forEach { tree.deleteDocument("shaders/vulkan/pipeline/$it") }
        }
    }
}

private enum class ShaderCacheBackend { OPENGL, VULKAN }

/**
 * Builds the intent a pinned shortcut for [game] should launch.
 *
 * [ShortcutInfo] stores its intent's extras in a [android.os.PersistableBundle], which only
 * accepts primitive values, so this can't reuse [EmulationLaunchRepository.createLaunchIntent]
 * as is: that intent's `game` extra is the whole [Game] object, and handing it to
 * [ShortcutInfo.Builder.build] throws `IllegalArgumentException`. Carrying only the launch URI is
 * enough: `EmulationFragment` already reconstructs the [Game] from it when no `game` extra is
 * present, the same path "open with" uses.
 */
private fun buildShortcutIntent(
    context: Context,
    game: Game,
    emulationLaunchRepository: EmulationLaunchRepository
): Intent = Intent(context, EmulationActivity::class.java).apply {
    action = Intent.ACTION_VIEW
    data = emulationLaunchRepository.createLaunchIntent(game).data
    putExtra("launched_from_shortcut", true)
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
    val emulationLaunchRepository = remember { EmulationLaunchRepository() }
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
                if (game.isInstalled) {
                    OpenFolderMenuButton(game)
                    Spacer(Modifier.width(8.dp))
                    UninstallMenuButton(game, onUninstalled = onDismiss)
                    Spacer(Modifier.width(8.dp))
                }
                IconButton(onClick = {
                    val shortcutManager = context.getSystemService(ShortcutManager::class.java)
                    scope.launch {
                        val icon = withContext(Dispatchers.IO) {
                            GameIconUtils.loadGameIconBitmapBlocking(game)
                        }?.let { Icon.createWithBitmap(it) }
                        val shortcut = ShortcutInfo.Builder(context, game.title)
                            .setShortLabel(game.title)
                            .apply { if (icon != null) setIcon(icon) }
                            .setIntent(buildShortcutIntent(context, game, emulationLaunchRepository))
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
            Row {
                Button(onClick = onCheats) { Text(stringResource(R.string.cheats)) }
                if (game.isInstalled) {
                    Spacer(Modifier.width(8.dp))
                    DeleteShaderCacheButton(game.titleId)
                }
            }
        }
    }
}

/**
 * Mirrors the desktop client's "Delete Shader Cache" action: asks which graphics backend's cache
 * to delete, then removes it via [deleteShaderCache].
 */
@Composable
private fun DeleteShaderCacheButton(titleId: Long) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()
    var showBackendPicker by remember { mutableStateOf(false) }
    var selectedBackend by remember { mutableStateOf<ShaderCacheBackend?>(null) }

    Button(onClick = { showBackendPicker = true; selectedBackend = null }) {
        Text(stringResource(R.string.delete_shader_cache))
    }

    if (showBackendPicker) {
        AlertDialog(
            onDismissRequest = { showBackendPicker = false },
            title = { Text(stringResource(R.string.delete_cache_select_backend)) },
            text = {
                Column {
                    listOf(
                        ShaderCacheBackend.VULKAN to R.string.vulkan,
                        ShaderCacheBackend.OPENGL to R.string.opengles
                    ).forEach { (backend, labelRes) ->
                        Row(
                            Modifier
                                .fillMaxWidth()
                                .clickable { selectedBackend = backend },
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            RadioButton(
                                selected = selectedBackend == backend,
                                onClick = { selectedBackend = backend }
                            )
                            Text(stringResource(labelRes))
                        }
                    }
                }
            },
            confirmButton = {
                TextButton(
                    enabled = selectedBackend != null,
                    onClick = {
                        val backend = selectedBackend!!
                        showBackendPicker = false
                        scope.launch(Dispatchers.IO) {
                            deleteShaderCache(titleId, backend)
                            withContext(Dispatchers.Main) {
                                Toast.makeText(
                                    context,
                                    R.string.shader_cache_deleted,
                                    Toast.LENGTH_SHORT
                                ).show()
                            }
                        }
                    }
                ) {
                    Text(stringResource(android.R.string.ok))
                }
            },
            dismissButton = {
                TextButton(onClick = { showBackendPicker = false }) {
                    Text(stringResource(android.R.string.cancel))
                }
            }
        )
    }
}

/**
 * Mirrors the desktop client's "Open" submenu (`GameList::AddGamePopup`'s `open_menu`): shows the
 * SAF-backed folders [game] has, opening the chosen one in a file manager. Application/Save
 * Data/Updates/DLC/Extra Data only enable once their folder exists; Textures/Mods stay enabled
 * and are created on demand when opened, matching `GameAdapter.showOpenContextMenu`.
 */
@Composable
private fun OpenFolderMenuButton(game: Game) {
    val context = LocalContext.current
    var expanded by remember { mutableStateOf(false) }
    val dirs = remember(game) { getGameDirectories(game) }
    val checkedEntries = remember(dirs) {
        listOf(
            R.string.game_context_open_app to dirs.appDir,
            R.string.game_context_open_save_dir to dirs.saveDir,
            R.string.game_context_open_updates to dirs.updatesDir,
            R.string.game_context_open_dlc to dirs.dlcDir,
            R.string.game_context_open_extra to dirs.extraDir
        )
    }
    val createOnOpenEntries = remember(dirs) {
        listOf(
            R.string.game_context_open_textures to dirs.texturesDir,
            R.string.game_context_open_mods to dirs.modsDir
        )
    }

    fun open(dir: String, createIfNotExists: Boolean) {
        val uri = CitraApplication.documentsTree.folderUriHelper(dir, createIfNotExists) ?: return
        context.startActivity(
            Intent(Intent.ACTION_VIEW)
                .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                .setDataAndType(uri, "*/*")
        )
    }

    Box {
        IconButton(onClick = { expanded = true }) {
            M3Icon(painterResource(R.drawable.ic_folder), contentDescription = null)
        }
        DropdownMenu(expanded = expanded, onDismissRequest = { expanded = false }) {
            checkedEntries.forEach { (labelRes, dir) ->
                val exists = CitraApplication.documentsTree.folderUriHelper(dir)?.let {
                    DocumentFile.fromTreeUri(context, it)?.exists()
                } ?: false
                DropdownMenuItem(
                    text = { Text(stringResource(labelRes)) },
                    enabled = exists,
                    onClick = {
                        expanded = false
                        open(dir, createIfNotExists = false)
                    }
                )
            }
            createOnOpenEntries.forEach { (labelRes, dir) ->
                DropdownMenuItem(
                    text = { Text(stringResource(labelRes)) },
                    onClick = {
                        expanded = false
                        open(dir, createIfNotExists = true)
                    }
                )
            }
        }
    }
}

/**
 * Mirrors the desktop client's "Uninstall" submenu (`GameList::AddGamePopup`'s `uninstall_menu`):
 * removes the content folder of [game] itself, its updates or its DLC. This is the same effect as
 * `Service::AM::UninstallProgram` (it only ever deletes a title's `content/` folder), done directly
 * through the SAF-backed [org.citra.citra_emu.utils.DocumentsTree] instead of a native call.
 */
@Composable
private fun UninstallMenuButton(game: Game, onUninstalled: () -> Unit) {
    val context = LocalContext.current
    var expanded by remember { mutableStateOf(false) }
    val dirs = remember(game) { getGameDirectories(game) }
    val entries = remember(dirs) {
        listOf(
            R.string.uninstall_cia to dirs.gameDir,
            R.string.game_context_uninstall_updates to dirs.updatesDir,
            R.string.game_context_uninstall_dlc to dirs.dlcDir
        )
    }

    Box {
        IconButton(onClick = { expanded = true }) {
            M3Icon(painterResource(R.drawable.ic_delete), contentDescription = null)
        }
        DropdownMenu(expanded = expanded, onDismissRequest = { expanded = false }) {
            entries.forEach { (labelRes, dir) ->
                val exists = CitraApplication.documentsTree.folderUriHelper(dir)?.let {
                    DocumentFile.fromTreeUri(context, it)?.exists()
                } ?: false
                DropdownMenuItem(
                    text = { Text(stringResource(labelRes)) },
                    enabled = exists,
                    onClick = {
                        expanded = false
                        if (CitraApplication.documentsTree.deleteDocument(dir)) {
                            onUninstalled()
                        }
                    }
                )
            }
        }
    }
}
