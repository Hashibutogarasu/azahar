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
}
