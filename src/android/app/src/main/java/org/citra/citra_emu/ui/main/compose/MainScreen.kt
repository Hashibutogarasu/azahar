// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.main.compose

import android.content.Context
import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.animation.AnimatedContentTransitionScope
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.core.CubicBezierEasing
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.slideOutVertically
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.consumeWindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
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
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.res.booleanResource
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.LayoutDirection
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.compose.LocalLifecycleOwner
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation.NavBackStackEntry
import androidx.navigation.NavController
import androidx.navigation.compose.rememberNavController
import androidx.preference.PreferenceManager
import com.ramcosta.composedestinations.DestinationsNavHost
import com.ramcosta.composedestinations.animations.NavHostAnimatedDestinationStyle
import com.ramcosta.composedestinations.generated.NavGraphs
import com.ramcosta.composedestinations.generated.destinations.GamesScreenDestination
import com.ramcosta.composedestinations.generated.destinations.HomeSettingsScreenDestination
import com.ramcosta.composedestinations.generated.destinations.SetupScreenDestination
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import com.ramcosta.composedestinations.navigation.dependency
import com.ramcosta.composedestinations.utils.currentDestinationAsState
import com.ramcosta.composedestinations.utils.toDestinationsNavigator
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.R
import org.citra.citra_emu.features.settings.model.Settings
import org.citra.citra_emu.features.settings.ui.SettingsActivity
import org.citra.citra_emu.features.settings.utils.SettingsFile
import org.citra.citra_emu.ui.main.compose.dialogs.CitraDirectoryDialog
import org.citra.citra_emu.ui.main.compose.dialogs.CopyDirProgressDialog
import org.citra.citra_emu.ui.main.compose.dialogs.SelectUserDirectoryDialog
import org.citra.citra_emu.ui.main.compose.dialogs.UpdateUserDirectoryDialog
import org.citra.citra_emu.utils.CitraDirectoryHelper
import org.citra.citra_emu.utils.CitraDirectoryUtils
import org.citra.citra_emu.utils.DirectoryInitialization
import org.citra.citra_emu.utils.PermissionsHandler
import org.citra.citra_emu.utils.ThemeUtil
import org.citra.citra_emu.viewmodel.DriverViewModel
import org.citra.citra_emu.viewmodel.GamesViewModel
import org.citra.citra_emu.viewmodel.HomeViewModel
import org.citra.citra_emu.viewmodel.TaskViewModel

/**
 * MainActivity's whole screen: bottom navigation across the Games/Search/HomeSettings tabs,
 * a [DestinationsNavHost] graph for every other destination reachable from them, and the
 * directory-permission dialogs that used to be shown ad hoc via the FragmentManager. Mirrors
 * the legacy `activity_main.xml` + `home_navigation.xml` + the relevant parts of
 * `MainActivity`.
 *
 * The Activity-scoped view models are shared with every destination via
 * [DestinationsNavHost]'s dependency container rather than being passed down as parameters, so
 * each `@Destination` composable just declares the ones it needs.
 */
private object MainNavTransitions : NavHostAnimatedDestinationStyle() {
    override val enterTransition: AnimatedContentTransitionScope<NavBackStackEntry>.() -> EnterTransition
        get() = { fadeIn(tween(300)) }
    override val exitTransition: AnimatedContentTransitionScope<NavBackStackEntry>.() -> ExitTransition
        get() = { fadeOut(tween(300)) }
}

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
    val navigator = navController.toDestinationsNavigator()

    val startRoute = remember {
        val firstTimeSetup = PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
            .getBoolean(Settings.PREF_FIRST_APP_LAUNCH, true)
        if (firstTimeSetup && !homeViewModel.navigatedToSetup) {
            homeViewModel.navigatedToSetup = true
            SetupScreenDestination
        } else {
            GamesScreenDestination
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
                gamesViewModel.refresh()
                driverViewModel.refresh()
            }
        }
        lifecycleOwner.lifecycle.addObserver(observer)
        onDispose { lifecycleOwner.lifecycle.removeObserver(observer) }
    }

    val smallLayout = booleanResource(R.bool.small_layout)
    val layoutDirection = LocalLayoutDirection.current
    val showEasing = CubicBezierEasing(0.05f, 0.7f, 0.1f, 1f)
    val hideEasing = CubicBezierEasing(0.3f, 0f, 0.8f, 0.15f)
    val chromeEnter = when {
        !navigationVisible.second -> EnterTransition.None
        smallLayout -> slideInVertically(tween(300, easing = showEasing)) { it * 2 }
        layoutDirection == LayoutDirection.Ltr ->
            slideInHorizontally(tween(300, easing = showEasing)) { -it * 2 }
        else -> slideInHorizontally(tween(300, easing = showEasing)) { it * 2 }
    }
    val chromeExit = when {
        !navigationVisible.second -> ExitTransition.None
        smallLayout -> slideOutVertically(tween(300, easing = hideEasing)) { it * 2 }
        layoutDirection == LayoutDirection.Ltr ->
            slideOutHorizontally(tween(300, easing = hideEasing)) { -it * 2 }
        else -> slideOutHorizontally(tween(300, easing = hideEasing)) { it * 2 }
    }

    Box(modifier.fillMaxSize()) {
        Scaffold(
            bottomBar = {
                AnimatedVisibility(
                    visible = navigationVisible.first,
                    enter = chromeEnter,
                    exit = chromeExit
                ) {
                    MainBottomNavigation(navController, navigator, gamesViewModel, context)
                }
            }
        ) { contentPadding ->
            DestinationsNavHost(
                navGraph = NavGraphs.root,
                start = startRoute,
                navController = navController,
                defaultTransitions = MainNavTransitions,
                modifier = Modifier
                    .padding(contentPadding)
                    .consumeWindowInsets(contentPadding),
                dependenciesContainerBuilder = {
                    dependency(homeViewModel)
                    dependency(gamesViewModel)
                    dependency(driverViewModel)
                    dependency(taskViewModel)
                }
            )
        }

        AnimatedVisibility(
            visible = statusBarShadeVisible,
            enter = slideInVertically(tween(300, easing = showEasing)) { -it * 2 },
            exit = slideOutVertically(tween(300, easing = hideEasing)) { -it * 2 },
            modifier = Modifier
                .align(Alignment.TopCenter)
                .fillMaxWidth()
        ) {
            Surface(
                color = MaterialTheme.colorScheme.surface.copy(alpha = ThemeUtil.SYSTEM_BAR_ALPHA),
                modifier = Modifier
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
    navigator: DestinationsNavigator,
    gamesViewModel: GamesViewModel,
    context: Context
) {
    val currentDestination by navController.currentDestinationAsState()

    val isGamesSelected = currentDestination == GamesScreenDestination

    NavigationBar {
        NavigationBarItem(
            selected = isGamesSelected,
            onClick = {
                if (isGamesSelected) {
                    gamesViewModel.setShouldScrollToTop(true)
                } else {
                    navigator.navigate(GamesScreenDestination) { launchSingleTop = true }
                }
            },
            icon = {
                val iconId = if (isGamesSelected) R.drawable.ic_controller else R.drawable.ic_controller_outline
                Icon(painterResource(iconId), contentDescription = null)
            },
            label = { Text(stringResource(R.string.home_games)) }
        )
        NavigationBarItem(
            selected = currentDestination == HomeSettingsScreenDestination,
            onClick = {
                if (currentDestination == HomeSettingsScreenDestination) {
                    SettingsActivity.launch(context, SettingsFile.FILE_NAME_CONFIG, "")
                } else {
                    navigator.navigate(HomeSettingsScreenDestination) { launchSingleTop = true }
                }
            },
            icon = { Icon(painterResource(R.drawable.ic_more), contentDescription = null) },
            label = { Text(stringResource(R.string.home_options)) }
        )
    }
}
