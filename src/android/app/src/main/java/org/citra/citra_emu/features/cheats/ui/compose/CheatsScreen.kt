// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.cheats.ui.compose

import androidx.activity.compose.BackHandler
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.windowInsetsBottomHeight
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import org.citra.citra_emu.features.cheats.model.CheatsViewModel
import org.citra.citra_emu.utils.InsetsHelper
import org.citra.citra_emu.utils.ThemeUtil

/**
 * Master-detail cheats screen. Mirrors the legacy `CheatsFragment` +
 * `SlidingPaneLayout` pair: on wide screens both panes are shown side by
 * side at all times, on narrow screens only one pane is shown and the
 * system back button closes the details pane before leaving the screen.
 *
 * @param onNavigateBack invoked when the user backs out of the list pane
 * itself (finish the hosting Activity, or pop the hosting back stack when
 * embedded as a destination inside another Activity's navigation graph).
 * @param twoPaneMinWidth screen width at or above which both panes are
 * shown side by side instead of one at a time.
 */
@Composable
fun CheatsScreen(
    cheatsViewModel: CheatsViewModel,
    onNavigateBack: () -> Unit,
    modifier: Modifier = Modifier,
    twoPaneMinWidth: Dp = 600.dp
) {
    val selectedCheat by cheatsViewModel.selectedCheat.collectAsStateWithLifecycle()
    val isEditing by cheatsViewModel.isEditing.collectAsStateWithLifecycle()
    val openEvent by cheatsViewModel.openDetailsViewEvent.collectAsStateWithLifecycle()
    val closeEvent by cheatsViewModel.closeDetailsViewEvent.collectAsStateWithLifecycle()

    var detailsOpen by rememberSaveable { mutableStateOf(false) }

    LaunchedEffect(openEvent) { if (openEvent) detailsOpen = true }
    LaunchedEffect(closeEvent) { if (closeEvent) detailsOpen = false }
    LaunchedEffect(selectedCheat, isEditing) {
        if (selectedCheat == null && !isEditing) detailsOpen = false
    }

    Box(modifier.fillMaxSize()) {
        BoxWithConstraints(Modifier.fillMaxSize()) {
            if (maxWidth >= twoPaneMinWidth) {
                Row(Modifier.fillMaxSize()) {
                    CheatListPane(
                        cheatsViewModel,
                        onNavigateBack = onNavigateBack,
                        modifier = Modifier.weight(1f)
                    )
                    CheatDetailsPane(
                        cheatsViewModel,
                        onClose = { cheatsViewModel.closeDetailsView() },
                        modifier = Modifier.weight(1f)
                    )
                }
            } else {
                BackHandler(enabled = detailsOpen) { cheatsViewModel.closeDetailsView() }
                if (detailsOpen) {
                    CheatDetailsPane(
                        cheatsViewModel,
                        onClose = { cheatsViewModel.closeDetailsView() },
                        modifier = Modifier.fillMaxSize()
                    )
                } else {
                    CheatListPane(
                        cheatsViewModel,
                        onNavigateBack = onNavigateBack,
                        modifier = Modifier.fillMaxSize()
                    )
                }
            }
        }

        val context = LocalContext.current
        if (InsetsHelper.getSystemGestureType(context) != InsetsHelper.GESTURE_NAVIGATION) {
            Box(
                modifier = Modifier
                    .align(Alignment.BottomCenter)
                    .fillMaxWidth()
                    .windowInsetsBottomHeight(WindowInsets.navigationBars)
                    .background(
                        MaterialTheme.colorScheme.surface.copy(alpha = ThemeUtil.SYSTEM_BAR_ALPHA)
                    )
            )
        }
    }
}
