package org.citra.citra_emu.ui.game

import android.view.SurfaceView
import android.view.View
import androidx.activity.compose.BackHandler
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import kotlinx.coroutines.launch
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.overlay.InputOverlay
import org.citra.citra_emu.ui.components.GameIcon

@Suppress("COMPOSE_APPLIER_CALL_MISMATCH")
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun EmulationScreen(
    game: Game,
    isDrawerOpen: Boolean,
    onCloseDrawer: () -> Unit,
    isSaveStateMenuOpen: Boolean,
    onCloseSaveStateMenu: () -> Unit,
    isLayoutMenuOpen: Boolean,
    onCloseLayoutMenu: () -> Unit,
    onSurfaceCreated: (SurfaceView) -> Unit,
    onOverlayCreated: (InputOverlay) -> Unit,
    menuItems: List<EmulationMenuItem>,
    loadingState: LoadingState = LoadingState.Hidden,
    performanceText: String? = null,
    modifier: Modifier = Modifier
) {
    val drawerState = rememberDrawerState(
        initialValue = if (isDrawerOpen) DrawerValue.Open else DrawerValue.Closed
    )
    val saveStateSheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    val layoutSheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)

    LaunchedEffect(isDrawerOpen) {
        if (isDrawerOpen && drawerState.isClosed) {
            drawerState.open()
        } else if (!isDrawerOpen && drawerState.isOpen) {
            drawerState.close()
        }
    }

    LaunchedEffect(drawerState.isOpen) {
        if (drawerState.isClosed && isDrawerOpen) {
            onCloseDrawer()
        }
    }

    LaunchedEffect(isSaveStateMenuOpen) {
        if (isSaveStateMenuOpen) {
            saveStateSheetState.show()
        } else {
            saveStateSheetState.hide()
        }
    }

    LaunchedEffect(isLayoutMenuOpen) {
        if (isLayoutMenuOpen) {
            layoutSheetState.show()
        } else {
            layoutSheetState.hide()
        }
    }

    BackHandler(enabled = drawerState.isOpen) {
        onCloseDrawer()
    }

    ModalNavigationDrawer(
        drawerState = drawerState,
        gesturesEnabled = !isSaveStateMenuOpen && !isLayoutMenuOpen,
        drawerContent = {
            ModalDrawerSheet {
                EmulationMenu(
                    items = menuItems,
                    headerContent = {
                        GameMenuHeader(game = game)
                    }
                )
            }
        },
        content = {
            Box(modifier = modifier.fillMaxSize()) {
                // Emulation Surface
                AndroidView(
                    factory = { context ->
                        SurfaceView(context).apply {
                            // ID is important if used elsewhere, but ideally we pass requirements
                            // Keep layout params matching parent
                        }
                    },
                    update = { view ->
                        onSurfaceCreated(view)
                    },
                    modifier = Modifier.fillMaxSize()
                )

                // Input Overlay
                val overlayAlpha = if (loadingState is LoadingState.Helpers) 0f else 1f
                AndroidView(
                    factory = { context ->
                        InputOverlay(context, null).apply {
                            visibility = View.VISIBLE
                        }
                    },
                    update = { view ->
                        onOverlayCreated(view)
                        view.alpha = overlayAlpha
                    },
                    modifier = Modifier.fillMaxSize()
                )

                // Loading Indicator
                if (loadingState is LoadingState.Visible) {
                    Box(
                        modifier = Modifier
                            .align(Alignment.Center)
                            .wrapContentSize(),
                        contentAlignment = Alignment.Center
                    ) {
                        LoadingCard(loadingState, game)
                    }
                }

                // Performance Text
                if (!performanceText.isNullOrEmpty()) {
                    Text(
                        text = performanceText,
                        color = MaterialTheme.colorScheme.onSurface, // Or White as per original
                        style = MaterialTheme.typography.bodySmall,
                        modifier = Modifier
                            .align(Alignment.TopStart) // Or configurable position
                            .padding(8.dp) // Just some padding
                    )
                }

                if (isSaveStateMenuOpen) {
                    ModalBottomSheet(
                        onDismissRequest = onCloseSaveStateMenu,
                        sheetState = saveStateSheetState
                    ) {
                        // TODO: Use a proper Composable for SaveStates
                        Box(
                            Modifier
                                .fillMaxWidth()
                                .height(200.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            Text("Save States Menu Placeholder")
                        }
                    }
                }

                if (isLayoutMenuOpen) {
                    ModalBottomSheet(
                        onDismissRequest = onCloseLayoutMenu,
                        sheetState = layoutSheetState
                    ) {
                        // TODO: Use a proper Composable for Layout Options
                        Box(
                            Modifier
                                .fillMaxWidth()
                                .height(200.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            Text("Layout Options Menu Placeholder")
                        }
                    }
                }
            }
        }
    )
}

sealed class LoadingState {
    object Hidden : LoadingState()
    object Helpers : LoadingState() // Hidden overlay but no card
    data class Visible(
        val title: String,
        val description: String,
        val progress: Int?,
        val max: Int?
    ) : LoadingState()
}

@Composable
fun LoadingCard(state: LoadingState.Visible, game: Game) {
    Card(
        elevation = CardDefaults.cardElevation(defaultElevation = 6.dp)
    ) {
        Row(
            modifier = Modifier.padding(24.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            GameIcon(
                game = game,
                modifier = Modifier.size(48.dp),
                cornerRadius = 8.dp
            )
            Spacer(modifier = Modifier.width(16.dp))
            Column {
                Text(text = state.title, style = MaterialTheme.typography.titleMedium)
                Spacer(modifier = Modifier.height(4.dp))
                Text(text = state.description, style = MaterialTheme.typography.bodyMedium)
                if (state.progress != null && state.max != null) {
                    Spacer(modifier = Modifier.height(12.dp))
                    LinearProgressIndicator(
                        progress = { state.progress.toFloat() / state.max.toFloat() }
                    )
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        text = "${state.progress}/${state.max}",
                        style = MaterialTheme.typography.labelSmall
                    )
                } else {
                    Spacer(modifier = Modifier.height(12.dp))
                    LinearProgressIndicator()
                }
            }
        }
    }
}

@Composable
fun GameMenuHeader(
    game: Game,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 24.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        GameIcon(
            game = game,
            modifier = Modifier.size(64.dp),
            cornerRadius = 12.dp
        )
        Spacer(modifier = Modifier.width(16.dp))
        Text(
            text = game.title,
            style = MaterialTheme.typography.titleLarge,
            color = MaterialTheme.colorScheme.onSurface
        )
    }
}
