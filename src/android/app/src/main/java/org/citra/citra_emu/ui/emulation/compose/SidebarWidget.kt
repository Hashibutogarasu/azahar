// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version.
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.emulation.compose

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
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
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import org.citra.citra_emu.R
import org.citra.citra_emu.NativeLibrary
import org.citra.citra_emu.viewmodel.SidebarViewModel

/** Groups actions invoked by the emulation sidebar. */
class SidebarActions(
    val onPauseResume: () -> Unit,
    val onAdvanceFrame: () -> Unit,
    val onSwapScreens: () -> Unit,
    val onHapticFeedbackChanged: () -> Unit,
    val onAutoDisableOverlayChanged: () -> Unit,
    val onDrawerLockChanged: () -> Unit,
    val onCheats: () -> Unit,
    val onSaveMemory: () -> Unit,
    val onRecordMemory: () -> Unit,
    val onSettings: () -> Unit,
    val onCloseGame: () -> Unit,
    val onSaveState: (Int) -> Unit = {},
    val onLoadState: (Int) -> Unit = {},
    val onShowOverlayChanged: () -> Unit = {},
    val onShowFpsChanged: () -> Unit = {},
    val onEditLayout: () -> Unit = {},
    val onToggleControls: () -> Unit = {},
    val onAdjustScale: (String) -> Unit = {},
    val onResetAllScales: () -> Unit = {},
    val onAdjustOpacity: () -> Unit = {},
    val onJoystickRelCenterChanged: () -> Unit = {},
    val onDpadSlideChanged: () -> Unit = {},
    val onResetOverlay: () -> Unit = {},
    val onLoadAmiibo: () -> Unit = {},
    val onRemoveAmiibo: () -> Unit = {}
)

/** Describes a savestate slot shown in the savestate bottom sheet. */
data class SidebarSavestateSlot(
    val slot: Int,
    val isQuickSave: Boolean,
    val emptyLabel: String,
    val occupiedLabel: String? = null
) {
    val canSave: Boolean get() = !isQuickSave
    val canLoad: Boolean get() = occupiedLabel != null
}

private val RecordingIntervalOptions = listOf(1, 2, 5, 10, 30, 60)

/** Renders the categorized drawer content used during emulation. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SidebarWidget(
    gameTitle: String,
    viewModel: SidebarViewModel,
    actions: SidebarActions,
    savestateSlotsProvider: () -> List<SidebarSavestateSlot> = { emptyList() },
    modifier: Modifier = Modifier
) {
    val isPaused by viewModel.isPaused.collectAsState()
    val savestatesAvailable by viewModel.savestatesAvailable.collectAsState()
    val hapticFeedback by viewModel.hapticFeedback.collectAsState()
    val autoDisableOverlayOnController by viewModel.autoDisableOverlayOnController.collectAsState()
    val drawerLocked by viewModel.drawerLocked.collectAsState()
    val isRecordingMemory by viewModel.isRecordingMemory.collectAsState()
    val activeSheet by viewModel.activeSheet.collectAsState()
    val intervalFrames by viewModel.memoryRecordingIntervalFrames.collectAsState()
    val showOverlay by viewModel.showOverlay.collectAsState()
    val showFps by viewModel.showFps.collectAsState()
    val joystickRelCenter by viewModel.joystickRelCenter.collectAsState()
    val dpadSlide by viewModel.dpadSlide.collectAsState()

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
                    onClick = { viewModel.showSheet(SidebarViewModel.Sheet.SAVESTATES) }
                )
            }
            MenuItem(
                icon = R.drawable.ic_nfc,
                title = stringResource(R.string.menu_emulation_amiibo),
                onClick = { viewModel.showSheet(SidebarViewModel.Sheet.AMIIBO) }
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
                onClick = { viewModel.showSheet(SidebarViewModel.Sheet.OVERLAY_OPTIONS) }
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
            MenuItem(
                icon = R.drawable.ic_record,
                title = stringResource(R.string.memory_recording_interval),
                onClick = { viewModel.showSheet(SidebarViewModel.Sheet.RECORDING_INTERVAL) }
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

        activeSheet?.let { sheet ->
            ModalBottomSheet(onDismissRequest = viewModel::dismissSheet) {
                when (sheet) {
                    SidebarViewModel.Sheet.SAVESTATES -> SavestatesSheet(
                        slots = remember(sheet) { savestateSlotsProvider() },
                        onSave = { slot -> viewModel.dismissSheet(); actions.onSaveState(slot) },
                        onLoad = { slot -> viewModel.dismissSheet(); actions.onLoadState(slot) }
                    )
                    SidebarViewModel.Sheet.OVERLAY_OPTIONS -> OverlayOptionsSheet(
                        showOverlay = showOverlay,
                        showFps = showFps,
                        joystickRelCenter = joystickRelCenter,
                        dpadSlide = dpadSlide,
                        actions = actions
                    )
                    SidebarViewModel.Sheet.AMIIBO -> AmiiboSheet(
                        onLoad = { viewModel.dismissSheet(); actions.onLoadAmiibo() },
                        onRemove = { viewModel.dismissSheet(); actions.onRemoveAmiibo() }
                    )
                    SidebarViewModel.Sheet.RECORDING_INTERVAL -> RecordingIntervalSheet(
                        selected = intervalFrames,
                        onSelected = { value ->
                            viewModel.setMemoryRecordingIntervalFrames(value)
                            viewModel.dismissSheet()
                        }
                    )
                }
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

@Composable
private fun SavestatesSheet(
    slots: List<SidebarSavestateSlot>,
    onSave: (Int) -> Unit,
    onLoad: (Int) -> Unit
) {
    SheetColumn {
        Text(
            text = stringResource(R.string.savestates),
            modifier = Modifier.padding(start = 24.dp, top = 8.dp, end = 24.dp, bottom = 16.dp),
            style = MaterialTheme.typography.titleLarge,
            color = MaterialTheme.colorScheme.onSurface
        )
        slots.forEach { slot ->
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 24.dp, vertical = 8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = slot.occupiedLabel ?: slot.emptyLabel,
                    modifier = Modifier.weight(1f),
                    style = MaterialTheme.typography.bodyLarge,
                    color = MaterialTheme.colorScheme.onSurface
                )
                TextButton(
                    enabled = slot.canSave,
                    onClick = { onSave(slot.slot) }
                ) { Text(stringResource(R.string.emulation_save_state)) }
                TextButton(
                    enabled = slot.canLoad,
                    onClick = { onLoad(slot.slot) }
                ) { Text(stringResource(R.string.emulation_load_state)) }
            }
        }
    }
}

@Composable
private fun AmiiboSheet(
    onLoad: () -> Unit,
    onRemove: () -> Unit
) {
    SheetColumn {
        SheetAction(stringResource(R.string.menu_emulation_amiibo_load), onClick = onLoad)
        SheetAction(stringResource(R.string.menu_emulation_amiibo_remove), onClick = onRemove)
    }
}

@Composable
private fun RecordingIntervalSheet(
    selected: Int,
    onSelected: (Int) -> Unit
) {
    SheetColumn {
        Text(
            text = stringResource(R.string.memory_recording_interval),
            modifier = Modifier.padding(start = 24.dp, top = 8.dp, end = 24.dp, bottom = 16.dp),
            style = MaterialTheme.typography.titleLarge,
            color = MaterialTheme.colorScheme.onSurface
        )
        RecordingIntervalOptions.forEach { frames ->
            SheetAction(
                title = stringResource(R.string.memory_recording_interval_every, frames),
                checked = frames == selected,
                onClick = { onSelected(frames) }
            )
        }
    }
}

@Composable
private fun OverlayOptionsSheet(
    showOverlay: Boolean,
    showFps: Boolean,
    joystickRelCenter: Boolean,
    dpadSlide: Boolean,
    actions: SidebarActions
) {
    var showScaleMenu by remember { mutableStateOf(false) }
    SheetColumn {
        if (showScaleMenu) {
            SheetAction(
                stringResource(R.string.emulation_control_scale_reset_all),
                onClick = actions.onResetAllScales
            )
            val scaleOptions = listOf(
                R.string.emulation_control_scale_global to "controlScale",
                R.string.button_a to "controlScale-${NativeLibrary.ButtonType.BUTTON_A}",
                R.string.button_b to "controlScale-${NativeLibrary.ButtonType.BUTTON_B}",
                R.string.button_x to "controlScale-${NativeLibrary.ButtonType.BUTTON_X}",
                R.string.button_y to "controlScale-${NativeLibrary.ButtonType.BUTTON_Y}",
                R.string.button_l to "controlScale-${NativeLibrary.ButtonType.TRIGGER_L}",
                R.string.button_r to "controlScale-${NativeLibrary.ButtonType.TRIGGER_R}",
                R.string.button_zl to "controlScale-${NativeLibrary.ButtonType.BUTTON_ZL}",
                R.string.button_zr to "controlScale-${NativeLibrary.ButtonType.BUTTON_ZR}",
                R.string.button_start to "controlScale-${NativeLibrary.ButtonType.BUTTON_START}",
                R.string.button_select to "controlScale-${NativeLibrary.ButtonType.BUTTON_SELECT}",
                R.string.controller_dpad to "controlScale-${NativeLibrary.ButtonType.DPAD}",
                R.string.controller_circlepad to "controlScale-${NativeLibrary.ButtonType.STICK_LEFT}",
                R.string.controller_c to "controlScale-${NativeLibrary.ButtonType.STICK_C}",
                R.string.button_home to "controlScale-${NativeLibrary.ButtonType.BUTTON_HOME}",
                R.string.button_swap to "controlScale-${NativeLibrary.ButtonType.BUTTON_SWAP}"
            )
            scaleOptions.forEach { (labelRes, target) ->
                SheetAction(stringResource(labelRes)) { actions.onAdjustScale(target) }
            }
        } else {
            SheetAction(stringResource(R.string.emulation_show_overlay), checked = showOverlay, onClick = actions.onShowOverlayChanged)
            SheetAction(stringResource(R.string.emulation_show_fps), checked = showFps, onClick = actions.onShowFpsChanged)
            SheetAction(stringResource(R.string.emulation_edit_layout), onClick = actions.onEditLayout)
            SheetAction(stringResource(R.string.emulation_toggle_controls), onClick = actions.onToggleControls)
            SheetAction(stringResource(R.string.emulation_control_scale)) { showScaleMenu = true }
            SheetAction(stringResource(R.string.emulation_control_opacity), onClick = actions.onAdjustOpacity)
            SheetAction(stringResource(R.string.emulation_control_joystick_rel_center), checked = joystickRelCenter, onClick = actions.onJoystickRelCenterChanged)
            SheetAction(stringResource(R.string.emulation_control_dpad_slide_enable), checked = dpadSlide, onClick = actions.onDpadSlideChanged)
            SheetAction(stringResource(R.string.emulation_touch_overlay_reset), onClick = actions.onResetOverlay)
        }
    }
}

@Composable
private fun SheetColumn(content: @Composable ColumnScope.() -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(bottom = 32.dp),
        content = content
    )
}

@Composable
private fun SheetAction(
    title: String,
    checked: Boolean = false,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(horizontal = 24.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
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
