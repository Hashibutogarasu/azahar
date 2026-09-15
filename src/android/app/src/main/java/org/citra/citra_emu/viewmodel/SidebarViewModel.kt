// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version.
// Refer to the license.txt file included.

package org.citra.citra_emu.viewmodel

import androidx.drawerlayout.widget.DrawerLayout
import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import org.citra.citra_emu.utils.EmulationMenuSettings

/** Owns the state and user settings exposed by the emulation sidebar. */
class SidebarViewModel : ViewModel() {
    enum class Sheet {
        SAVESTATES,
        OVERLAY_OPTIONS,
        AMIIBO,
        RECORDING_INTERVAL
    }

    val isPaused get() = _isPaused.asStateFlow()
    private val _isPaused = MutableStateFlow(false)

    val savestatesAvailable get() = _savestatesAvailable.asStateFlow()
    private val _savestatesAvailable = MutableStateFlow(false)

    val hapticFeedback get() = _hapticFeedback.asStateFlow()
    private val _hapticFeedback = MutableStateFlow(EmulationMenuSettings.hapticFeedback)

    val autoDisableOverlayOnController get() = _autoDisableOverlayOnController.asStateFlow()
    private val _autoDisableOverlayOnController = MutableStateFlow(
        EmulationMenuSettings.autoDisableOverlayOnController
    )

    val drawerLocked get() = _drawerLocked.asStateFlow()
    private val _drawerLocked = MutableStateFlow(
        EmulationMenuSettings.drawerLockMode == DrawerLayout.LOCK_MODE_LOCKED_CLOSED
    )

    val isRecordingMemory get() = _isRecordingMemory.asStateFlow()
    private val _isRecordingMemory = MutableStateFlow(false)

    val activeSheet get() = _activeSheet.asStateFlow()
    private val _activeSheet = MutableStateFlow<Sheet?>(null)

    val memoryRecordingIntervalFrames get() = _memoryRecordingIntervalFrames.asStateFlow()
    private val _memoryRecordingIntervalFrames = MutableStateFlow(
        EmulationMenuSettings.memoryRecordingIntervalFrames
    )

    val showOverlay get() = _showOverlay.asStateFlow()
    private val _showOverlay = MutableStateFlow(EmulationMenuSettings.showOverlay)

    val showFps get() = _showFps.asStateFlow()
    private val _showFps = MutableStateFlow(EmulationMenuSettings.showFps)

    val joystickRelCenter get() = _joystickRelCenter.asStateFlow()
    private val _joystickRelCenter = MutableStateFlow(EmulationMenuSettings.joystickRelCenter)

    val dpadSlide get() = _dpadSlide.asStateFlow()
    private val _dpadSlide = MutableStateFlow(EmulationMenuSettings.dpadSlide)

    fun setPaused(value: Boolean) {
        _isPaused.value = value
    }

    fun setSavestatesAvailable(value: Boolean) {
        _savestatesAvailable.value = value
    }

    fun toggleHapticFeedback() {
        EmulationMenuSettings.hapticFeedback = !EmulationMenuSettings.hapticFeedback
        _hapticFeedback.value = EmulationMenuSettings.hapticFeedback
    }

    fun toggleAutoDisableOverlayOnController() {
        EmulationMenuSettings.autoDisableOverlayOnController =
            !EmulationMenuSettings.autoDisableOverlayOnController
        _autoDisableOverlayOnController.value =
            EmulationMenuSettings.autoDisableOverlayOnController
    }

    fun toggleDrawerLock() {
        val locked = EmulationMenuSettings.drawerLockMode ==
            DrawerLayout.LOCK_MODE_LOCKED_CLOSED
        EmulationMenuSettings.drawerLockMode = if (locked) {
            DrawerLayout.LOCK_MODE_UNLOCKED
        } else {
            DrawerLayout.LOCK_MODE_LOCKED_CLOSED
        }
        _drawerLocked.value = !locked
    }

    fun setRecordingMemory(value: Boolean) {
        _isRecordingMemory.value = value
    }

    fun showSheet(sheet: Sheet) {
        _activeSheet.value = sheet
    }

    fun dismissSheet() {
        _activeSheet.value = null
    }

    fun setMemoryRecordingIntervalFrames(value: Int) {
        EmulationMenuSettings.memoryRecordingIntervalFrames = value
        _memoryRecordingIntervalFrames.value = value
    }

    fun toggleShowOverlay() {
        EmulationMenuSettings.showOverlay = !EmulationMenuSettings.showOverlay
        _showOverlay.value = EmulationMenuSettings.showOverlay
    }

    fun toggleShowFps() {
        EmulationMenuSettings.showFps = !EmulationMenuSettings.showFps
        _showFps.value = EmulationMenuSettings.showFps
    }

    fun toggleJoystickRelCenter() {
        EmulationMenuSettings.joystickRelCenter = !EmulationMenuSettings.joystickRelCenter
        _joystickRelCenter.value = EmulationMenuSettings.joystickRelCenter
    }

    fun toggleDpadSlide() {
        EmulationMenuSettings.dpadSlide = !EmulationMenuSettings.dpadSlide
        _dpadSlide.value = EmulationMenuSettings.dpadSlide
    }
}
