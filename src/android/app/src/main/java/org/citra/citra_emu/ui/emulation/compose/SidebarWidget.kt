// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version.
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.emulation.compose

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import org.citra.citra_emu.R
import org.citra.citra_emu.viewmodel.SidebarViewModel

/** Groups actions invoked by the emulation sidebar. */
class SidebarActions(
    val onPauseResume: () -> Unit,
    val onAdvanceFrame: () -> Unit,
    val onSavestates: () -> Unit,
    val onOverlayOptions: () -> Unit,
    val onAmiibo: () -> Unit,
    val onSwapScreens: () -> Unit,
    val onHapticFeedbackChanged: () -> Unit,
    val onAutoDisableOverlayChanged: () -> Unit,
    val onDrawerLockChanged: () -> Unit,
    val onCheats: () -> Unit,
    val onSaveMemory: () -> Unit,
    val onRecordMemory: () -> Unit,
    val onSettings: () -> Unit,
    val onCloseGame: () -> Unit
)

/** Renders the categorized drawer content used during emulation. */
@Composable
fun SidebarWidget(
    gameTitle: String,
    viewModel: SidebarViewModel,
    actions: SidebarActions,
    modifier: Modifier = Modifier
) {
    val isPaused by viewModel.isPaused.collectAsState()
    val savestatesAvailable by viewModel.savestatesAvailable.collectAsState()
    val hapticFeedback by viewModel.hapticFeedback.collectAsState()
    val autoDisableOverlayOnController by viewModel.autoDisableOverlayOnController.collectAsState()
    val drawerLocked by viewModel.drawerLocked.collectAsState()
    val isRecordingMemory by viewModel.isRecordingMemory.collectAsState()

    Surface(
        modifier = modifier.fillMaxSize(),
        color = MaterialTheme.colorScheme.surface,
        shape = RoundedCornerShape(
            topEnd = 20.dp,
            bottomEnd = 20.dp
        )
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .width(300.dp)
                .verticalScroll(rememberScrollState())
                .padding(bottom = 16.dp)
        ) {
            Text(
                text = gameTitle,
                modifier = Modifier.padding(start = 24.dp, top = 24.dp, end = 24.dp, bottom = 16.dp),
                style = MaterialTheme.typography.headlineMedium,
                color = MaterialTheme.colorScheme.onSurface
            )

            MenuSection(stringResource(R.string.emulation_menu_section_emulation)) {
            MenuItem(
                icon = if (isPaused) R.drawable.ic_play else R.drawable.ic_pause,
                title = stringResource(
                    if (isPaused) R.string.resume_emulation else R.string.pause_emulation
                ),
                onClick = actions.onPauseResume
            )
            MenuItem(
                icon = R.drawable.ic_step_forward,
                title = stringResource(R.string.advance_frame),
                enabled = isPaused,
                onClick = actions.onAdvanceFrame
            )
            if (savestatesAvailable) {
                MenuItem(
                    icon = R.drawable.ic_save,
                    title = stringResource(R.string.savestates),
                    onClick = actions.onSavestates
                )
            }
            MenuItem(
                icon = R.drawable.ic_nfc,
                title = stringResource(R.string.menu_emulation_amiibo),
                onClick = actions.onAmiibo
            )
        }

            MenuSection(stringResource(R.string.emulation_menu_section_display)) {
            MenuItem(
                icon = R.drawable.ic_splitscreen,
                title = stringResource(R.string.emulation_swap_screens),
                onClick = actions.onSwapScreens
            )
        }

            MenuSection(stringResource(R.string.emulation_menu_section_controls)) {
            MenuItem(
                icon = R.drawable.ic_controller,
                title = stringResource(R.string.emulation_overlay_options),
                onClick = actions.onOverlayOptions
            )
            MenuItem(
                icon = R.drawable.ic_controller,
                title = stringResource(R.string.emulation_haptic_feedback),
                checked = hapticFeedback,
                onClick = actions.onHapticFeedbackChanged
            )
            MenuItem(
                icon = R.drawable.ic_controller,
                title = stringResource(R.string.emulation_auto_disable_overlay_on_controller),
                checked = autoDisableOverlayOnController,
                onClick = actions.onAutoDisableOverlayChanged
            )
        }

            MenuSection(stringResource(R.string.tools)) {
            MenuItem(
                icon = R.drawable.ic_code,
                title = stringResource(R.string.cheats),
                onClick = actions.onCheats
            )
            MenuItem(
                icon = R.drawable.ic_save,
                title = stringResource(R.string.save_current_memory),
                onClick = actions.onSaveMemory
            )
            MenuItem(
                icon = R.drawable.ic_record,
                title = stringResource(
                    if (isRecordingMemory) {
                        R.string.stop_memory_recording
                    } else {
                        R.string.start_memory_recording
                    }
                ),
                onClick = actions.onRecordMemory
            )
        }

            MenuSection(stringResource(R.string.emulation_menu_section_other)) {
            MenuItem(
                icon = if (drawerLocked) R.drawable.ic_lock else R.drawable.ic_unlocked,
                title = stringResource(
                    if (drawerLocked) R.string.unlock_drawer else R.string.lock_drawer
                ),
                onClick = actions.onDrawerLockChanged
            )
            MenuItem(
                icon = R.drawable.ic_settings,
                title = stringResource(R.string.preferences_settings),
                onClick = actions.onSettings
            )
            MenuItem(
                icon = R.drawable.ic_exit,
                title = stringResource(R.string.emulation_close_game),
                onClick = actions.onCloseGame
            )
            }
        }
    }
}

@Composable
private fun MenuSection(title: String, content: @Composable () -> Unit) {
    Text(
        text = title,
        modifier = Modifier.padding(start = 16.dp, top = 16.dp, end = 16.dp, bottom = 4.dp),
        style = MaterialTheme.typography.labelLarge,
        color = MaterialTheme.colorScheme.primary
    )
    content()
}

@Composable
private fun MenuItem(
    icon: Int,
    title: String,
    onClick: () -> Unit,
    checked: Boolean = false,
    enabled: Boolean = true
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .height(52.dp)
            .clickable(enabled = enabled, onClick = onClick)
            .alpha(if (enabled) 1f else 0.38f)
            .padding(start = 32.dp, end = 16.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.Start
    ) {
        Icon(
            painter = painterResource(icon),
            contentDescription = null,
            modifier = Modifier.size(24.dp),
            tint = MaterialTheme.colorScheme.onSurfaceVariant
        )
        Spacer(Modifier.width(16.dp))
        Text(
            text = title,
            modifier = Modifier.weight(1f),
            style = MaterialTheme.typography.bodyLarge,
            color = MaterialTheme.colorScheme.onSurface
        )
        if (checked) {
            Icon(
                painter = painterResource(R.drawable.ic_check),
                contentDescription = null,
                modifier = Modifier.size(24.dp),
                tint = MaterialTheme.colorScheme.primary
            )
        }
    }
}
