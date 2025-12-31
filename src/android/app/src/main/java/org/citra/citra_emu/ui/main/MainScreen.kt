package org.citra.citra_emu.ui.main
import android.os.Bundle
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.layout.windowInsetsTopHeight
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.viewinterop.AndroidViewBinding
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation.NavController
import androidx.navigation.NavDestination.Companion.hierarchy
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.fragment.NavHostFragment
import kotlinx.coroutines.launch
import org.citra.citra_emu.R
import org.citra.citra_emu.databinding.ContentMainBinding
import org.citra.citra_emu.ui.components.AppDrawer
import org.citra.citra_emu.ui.components.DrawerDestination
import org.citra.citra_emu.utils.ThemeUtil
import org.citra.citra_emu.viewmodel.HomeViewModel
import org.citra.citra_emu.HomeNavigationDirections
import androidx.navigation.navOptions
@Composable
fun MainScreen(
    homeViewModel: HomeViewModel,
    onNavControllerReady: (NavController) -> Unit,
    modifier: Modifier = Modifier
) {
    val drawerState = rememberDrawerState(DrawerValue.Closed)
    val scope = rememberCoroutineScope()
    var navController by remember { mutableStateOf<NavController?>(null) }
    val activity = LocalContext.current as? MainActivity
    DisposableEffect(activity) {
        activity?.drawerOpener = {
             scope.launch { drawerState.open() }
        }
        onDispose {
            activity?.drawerOpener = null
        }
    }
    val navigationVisible by homeViewModel.navigationVisible.collectAsStateWithLifecycle()
    val statusBarShadeVisible by homeViewModel.statusBarShadeVisible.collectAsStateWithLifecycle()
    var currentDestination by remember { mutableStateOf<androidx.navigation.NavDestination?>(null) }
    DisposableEffect(navController) {
        val controller = navController ?: return@DisposableEffect onDispose {}
        val listener = NavController.OnDestinationChangedListener { _, destination, _ ->
            currentDestination = destination
        }
        controller.addOnDestinationChangedListener(listener)
        currentDestination = controller.currentDestination
        onDispose {
            controller.removeOnDestinationChangedListener(listener)
        }
    }
    ModalNavigationDrawer(
        drawerState = drawerState,
        drawerContent = {
            AppDrawer(
                selectedDestination = when (currentDestination?.id) {
                    R.id.hiddenAppsFragment -> DrawerDestination.Hidden
                    else -> DrawerDestination.Applications
                },
                onDestinationSelected = { dest ->
                    scope.launch { drawerState.close() }
                    navController?.let { nav ->
                        try {
                            when (dest) {
                                DrawerDestination.Applications -> {
                                    if (nav.currentDestination?.id != R.id.gamesFragment) {
                                        nav.navigate(R.id.action_global_gamesFragment)
                                    }
                                }
                                DrawerDestination.Hidden -> {
                                    nav.navigate(R.id.action_global_hiddenAppsFragment)
                                }
                            }
                        } catch (e: IllegalArgumentException) {
                            e.printStackTrace()
                        }
                    }
                }
            )
        }
    ) {
        Scaffold(
            bottomBar = {
                if (navigationVisible.first) {
                    NavigationBar {
                        NavigationBarItem(
                            selected = currentDestination?.hierarchy?.any { it.id == R.id.gamesFragment } == true,
                            onClick = {
                                     navController?.let { nav: NavController ->
                                         nav.navigate(HomeNavigationDirections.actionGlobalGamesFragment(), navOptions {
                                             popUpTo(nav.graph.findStartDestination().id) {
                                                 saveState = true
                                             }
                                             launchSingleTop = true
                                             restoreState = true
                                         })
                                     }
                            },
                            icon = { Icon(painterResource(R.drawable.ic_controller), contentDescription = stringResource(R.string.home_games)) },
                            label = { Text(stringResource(R.string.home_games)) }
                        )
                        NavigationBarItem(
                            selected = currentDestination?.hierarchy?.any { it.id == R.id.homeSettingsFragment } == true,
                            onClick = {
                                navController?.let { nav: NavController ->
                                    nav.navigate(HomeNavigationDirections.actionGlobalHomeSettingsFragment(), navOptions {
                                        popUpTo(nav.graph.findStartDestination().id) {
                                            saveState = true
                                        }
                                        launchSingleTop = true
                                        restoreState = true
                                    })
                                }
                            },
                            icon = { Icon(painterResource(R.drawable.ic_more), contentDescription = stringResource(R.string.home_options)) },
                            label = { Text(stringResource(R.string.home_options)) }
                        )
                    }
                }
            },
            contentWindowInsets = WindowInsets(0,0,0,0)
        ) { innerPadding ->
            Column(Modifier.fillMaxSize().padding(bottom = innerPadding.calculateBottomPadding())) {
                 if (statusBarShadeVisible) {
                     Box(
                         Modifier
                             .fillMaxWidth()
                             .windowInsetsTopHeight(WindowInsets.statusBars)
                             .background(MaterialTheme.colorScheme.surface.copy(alpha = ThemeUtil.SYSTEM_BAR_ALPHA))
                     )
                 }
                 AndroidViewBinding(ContentMainBinding::inflate, Modifier.weight(1f)) {
                     if (navController == null) {
                         try {
                             val fragment = this.fragmentContainer.getFragment<NavHostFragment>()
                             val nav = fragment.navController
                             navController = nav
                             onNavControllerReady(nav)
                         } catch (e: Exception) {
                             // ignore
                         }
                     }
                 }
            }
        }
    }
}
