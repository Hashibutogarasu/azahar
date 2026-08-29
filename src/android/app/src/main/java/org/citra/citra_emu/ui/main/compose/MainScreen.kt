// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.main.compose

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.layout.windowInsetsTopHeight
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.foundation.layout.padding
import androidx.compose.ui.res.stringResource
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.compose.LocalLifecycleOwner
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import androidx.preference.PreferenceManager
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequest
import androidx.work.OutOfQuotaPolicy
import androidx.work.WorkManager
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.R
import org.citra.citra_emu.contracts.OpenFileResultContract
import org.citra.citra_emu.features.cheats.model.CheatsViewModel
import org.citra.citra_emu.features.cheats.ui.compose.CheatsScreen
import org.citra.citra_emu.features.settings.model.Settings
import org.citra.citra_emu.features.settings.ui.SettingsActivity
import org.citra.citra_emu.features.settings.utils.SettingsFile
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.ui.main.compose.dialogs.CitraDirectoryDialog
import org.citra.citra_emu.ui.main.compose.dialogs.CopyDirProgressDialog
import org.citra.citra_emu.ui.main.compose.dialogs.SelectUserDirectoryDialog
import org.citra.citra_emu.ui.main.compose.dialogs.UpdateUserDirectoryDialog
import org.citra.citra_emu.utils.CiaInstallWorker
import org.citra.citra_emu.utils.CitraDirectoryHelper
import org.citra.citra_emu.utils.CitraDirectoryUtils
import org.citra.citra_emu.utils.DirectoryInitialization
import org.citra.citra_emu.utils.FileBrowserHelper
import org.citra.citra_emu.utils.GameHelper
import org.citra.citra_emu.utils.PermissionsHandler
import org.citra.citra_emu.utils.ThemeUtil
import org.citra.citra_emu.viewmodel.DriverViewModel
import org.citra.citra_emu.viewmodel.GamesViewModel
import org.citra.citra_emu.viewmodel.HomeViewModel
import org.citra.citra_emu.viewmodel.TaskViewModel

/**
 * MainActivity's whole screen: bottom navigation across the Games/Search/HomeSettings tabs,
 * a Navigation Compose graph for every other destination reachable from them, and the
 * directory-permission dialogs that used to be shown ad hoc via the FragmentManager. Mirrors
 * the legacy `activity_main.xml` + `home_navigation.xml` + the relevant parts of
 * `MainActivity`.
 */
@Composable
fun MainScreen(
    homeViewModel: HomeViewModel,
    gamesViewModel: GamesViewModel,
    driverViewModel: DriverViewModel,
    taskViewModel: TaskViewModel,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val activity = context as AppCompatActivity
    val navController = rememberNavController()

    val startDestination = remember {
        val firstTimeSetup = PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
            .getBoolean(Settings.PREF_FIRST_APP_LAUNCH, true)
        if (firstTimeSetup && !homeViewModel.navigatedToSetup) {
            homeViewModel.navigatedToSetup = true
            "setup"
        } else {
            "games"
        }
    }

    val navigationVisible by homeViewModel.navigationVisible.collectAsStateWithLifecycle()
    val statusBarShadeVisible by homeViewModel.statusBarShadeVisible.collectAsStateWithLifecycle()
    val pendingDirectoryPath by homeViewModel.pendingDirectoryPath.collectAsStateWithLifecycle()
    val copyInProgress by homeViewModel.copyInProgressFlow.collectAsStateWithLifecycle()

    val openCitraDirectory = rememberLauncherForActivityResult(
        ActivityResultContracts.OpenDocumentTree()
    ) { uri: Uri? ->
        if (uri != null) {
            CitraDirectoryHelper(activity).showCitraDirectoryDialog(uri)
        }
    }

    val ciaFileInstaller = rememberLauncherForActivityResult(
        OpenFileResultContract()
    ) { result: Intent? ->
        if (result != null) {
            val selectedFiles = FileBrowserHelper.getSelectedFiles(result, context, listOf("cia"))
            if (selectedFiles == null) {
                Toast.makeText(context, R.string.cia_file_not_found, Toast.LENGTH_LONG).show()
            } else {
                WorkManager.getInstance(context).enqueueUniqueWork(
                    "installCiaWork",
                    ExistingWorkPolicy.APPEND_OR_REPLACE,
                    OneTimeWorkRequest.Builder(CiaInstallWorker::class.java)
                        .setInputData(Data.Builder().putStringArray("CIA_FILES", selectedFiles).build())
                        .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
                        .build()
                )
            }
        }
    }

    val getGamesDirectory = rememberLauncherForActivityResult(
        ActivityResultContracts.OpenDocumentTree()
    ) { uri: Uri? ->
        if (uri != null) {
            context.contentResolver.takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
            PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
                .edit().putString(GameHelper.KEY_GAME_PATH, uri.toString()).apply()
            Toast.makeText(context, R.string.games_dir_selected, Toast.LENGTH_LONG).show()
            homeViewModel.setGamesDir(activity, uri.path!!)
        }
    }

    var showSelectUserDirDialog by remember { mutableStateOf(false) }
    var showUpdateUserDirDialog by remember { mutableStateOf(false) }

    fun checkUserPermissions() {
        val firstTimeSetup = PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
            .getBoolean(Settings.PREF_FIRST_APP_LAUNCH, true)
        val isPickingUserDir = homeViewModel.isPickingUserDir.value
        showSelectUserDirDialog = !firstTimeSetup && !PermissionsHandler.hasWriteAccess(context) && !isPickingUserDir
        showUpdateUserDirDialog = !firstTimeSetup && !isPickingUserDir && CitraDirectoryUtils.needToUpdateManually()
    }

    val isPickingUserDir by homeViewModel.isPickingUserDir.collectAsStateWithLifecycle()
    LaunchedEffect(isPickingUserDir) { checkUserPermissions() }

    val lifecycleOwner = LocalLifecycleOwner.current
    DisposableEffect(lifecycleOwner) {
        val observer = LifecycleEventObserver { _, event ->
            if (event == Lifecycle.Event.ON_RESUME) {
                checkUserPermissions()
                ThemeUtil.setCorrectTheme(activity)
            }
        }
        lifecycleOwner.lifecycle.addObserver(observer)
        onDispose { lifecycleOwner.lifecycle.removeObserver(observer) }
    }

    Box(modifier.fillMaxSize()) {
        Scaffold(
            bottomBar = {
                AnimatedVisibility(
                    visible = navigationVisible.first,
                    enter = fadeIn(),
                    exit = fadeOut()
                ) {
                    MainBottomNavigation(navController, gamesViewModel, context)
                }
            }
        ) { contentPadding ->
            NavHost(
                navController = navController,
                startDestination = startDestination,
                modifier = Modifier.padding(contentPadding)
            ) {
                composable("games") {
                    GamesScreen(
                        gamesViewModel = gamesViewModel,
                        homeViewModel = homeViewModel,
                        onGameClick = { game -> context.startActivity(game.launchIntent) },
                        onCheatsClick = { game -> navController.navigate("cheats/${game.titleId}") }
                    )
                }
                composable("search") {
                    SearchScreen(
                        gamesViewModel = gamesViewModel,
                        homeViewModel = homeViewModel,
                        onGameClick = { game -> context.startActivity(game.launchIntent) },
                        onCheatsClick = { game -> navController.navigate("cheats/${game.titleId}") }
                    )
                }
                composable("homeSettings") {
                    HomeSettingsScreen(
                        homeViewModel = homeViewModel,
                        driverViewModel = driverViewModel,
                        onOpenSettings = { SettingsActivity.launch(context, SettingsFile.FILE_NAME_CONFIG, "") },
                        onOpenThemeSettings = { SettingsActivity.launch(context, Settings.SECTION_THEME, "") },
                        onInstallCia = { ciaFileInstaller.launch(true) },
                        onOpenCitraDirectory = { openCitraDirectory.launch(null) },
                        onOpenGamesDirectory = { getGamesDirectory.launch(Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).data) },
                        onNavigateToSystemFiles = { navController.navigate("systemFiles") },
                        onNavigateToDriverManager = { navController.navigate("driverManager") },
                        onNavigateToAbout = { navController.navigate("about") },
                        onConnectArticBase = { address ->
                            context.startActivity(
                                Game(
                                    title = context.getString(R.string.artic_base),
                                    path = "articbase://$address",
                                    filename = ""
                                ).launchIntent
                            )
                        }
                    )
                }
                composable("setup") {
                    SetupScreen(
                        homeViewModel = homeViewModel,
                        onFinishSetup = {
                            navController.navigate("games") {
                                popUpTo("setup") { inclusive = true }
                            }
                        },
                        onFinish = { activity.finish() }
                    )
                }
                composable("about") {
                    AboutScreen(
                        homeViewModel = homeViewModel,
                        onNavigateBack = { navController.popBackStack() },
                        onNavigateToLicenses = { navController.navigate("licenses") }
                    )
                }
                composable("licenses") {
                    LicensesScreen(homeViewModel = homeViewModel, onNavigateBack = { navController.popBackStack() })
                }
                composable("systemFiles") {
                    SystemFilesScreen(
                        homeViewModel = homeViewModel,
                        gamesViewModel = gamesViewModel,
                        onNavigateBack = { navController.popBackStack() },
                        onLaunchEmulation = { game -> context.startActivity(game.launchIntent) }
                    )
                }
                composable("driverManager") {
                    DriverManagerScreen(
                        homeViewModel = homeViewModel,
                        driverViewModel = driverViewModel,
                        taskViewModel = taskViewModel,
                        onNavigateBack = { navController.popBackStack() }
                    )
                }
                composable(
                    "cheats/{titleId}",
                    arguments = listOf(navArgument("titleId") { type = NavType.LongType })
                ) { backStackEntry ->
                    val titleId = backStackEntry.arguments?.getLong("titleId") ?: -1L
                    val cheatsViewModel: CheatsViewModel = viewModel()
                    LaunchedEffect(titleId) { cheatsViewModel.initialize(titleId) }
                    CheatsScreen(
                        cheatsViewModel = cheatsViewModel,
                        onNavigateBack = { navController.popBackStack() }
                    )
                }
            }
        }

        if (statusBarShadeVisible) {
            Surface(
                color = MaterialTheme.colorScheme.surface.copy(alpha = ThemeUtil.SYSTEM_BAR_ALPHA),
                modifier = Modifier
                    .align(Alignment.TopCenter)
                    .fillMaxWidth()
                    .windowInsetsTopHeight(WindowInsets.statusBars)
            ) {}
        }
    }

    if (showSelectUserDirDialog) {
        SelectUserDirectoryDialog(onConfirm = { openCitraDirectory.launch(null) })
    }

    if (showUpdateUserDirDialog) {
        val preferences = PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
        UpdateUserDirectoryDialog(
            currentPath = Uri.parse(preferences.getString("CITRA_DIRECTORY", "")).path.orEmpty(),
            priorPath = Uri.parse(preferences.getString("LIME3DS_DIRECTORY", "")).path.orEmpty(),
            onConfirm = { selected ->
                if (selected == 1) {
                    PermissionsHandler.setCitraDirectory(preferences.getString("LIME3DS_DIRECTORY", ""))
                }
                if (selected >= 0) {
                    CitraDirectoryUtils.removeLimeDirectoryPreference()
                    DirectoryInitialization.resetCitraDirectoryState()
                    DirectoryInitialization.start()
                }
                homeViewModel.setPickingUserDir(false)
                homeViewModel.setUserDir(activity, PermissionsHandler.citraDirectory.path!!)
                showUpdateUserDirDialog = false
            }
        )
    }

    pendingDirectoryPath?.let { path ->
        val showMoveDataCheckbox = remember(path) {
            PermissionsHandler.hasWriteAccess(context) &&
                PermissionsHandler.citraDirectory.toString() != path.toString()
        }
        CitraDirectoryDialog(
            path = path,
            showMoveDataCheckbox = showMoveDataCheckbox,
            onConfirm = { moveData ->
                homeViewModel.directoryListener?.onPressPositiveButton(moveData, path)
                homeViewModel.setPendingDirectoryPath(null)
            },
            onCancel = {
                if (!PermissionsHandler.hasWriteAccess(context)) {
                    openCitraDirectory.launch(null)
                }
                homeViewModel.setPendingDirectoryPath(null)
            }
        )
    }

    if (copyInProgress) {
        CopyDirProgressDialog(homeViewModel)
    }
}

@Composable
private fun MainBottomNavigation(
    navController: NavController,
    gamesViewModel: GamesViewModel,
    context: Context
) {
    val backStackEntry by navController.currentBackStackEntryAsState()
    val currentRoute = backStackEntry?.destination?.route

    NavigationBar {
        NavigationBarItem(
            selected = currentRoute == "games",
            onClick = {
                if (currentRoute == "games") {
                    gamesViewModel.setShouldScrollToTop(true)
                } else {
                    navController.navigate("games") { launchSingleTop = true }
                }
            },
            icon = { Icon(painterResource(R.drawable.selector_controller), contentDescription = null) },
            label = { Text(stringResource(R.string.home_games)) }
        )
        NavigationBarItem(
            selected = currentRoute == "search",
            onClick = {
                if (currentRoute == "search") {
                    gamesViewModel.setSearchFocused(true)
                } else {
                    navController.navigate("search") { launchSingleTop = true }
                }
            },
            icon = { Icon(painterResource(R.drawable.ic_search), contentDescription = null) },
            label = { Text(stringResource(R.string.home_search)) }
        )
        NavigationBarItem(
            selected = currentRoute == "homeSettings",
            onClick = {
                if (currentRoute == "homeSettings") {
                    SettingsActivity.launch(context, SettingsFile.FILE_NAME_CONFIG, "")
                } else {
                    navController.navigate("homeSettings") { launchSingleTop = true }
                }
            },
            icon = { Icon(painterResource(R.drawable.ic_more), contentDescription = null) },
            label = { Text(stringResource(R.string.home_options)) }
        )
    }
}
