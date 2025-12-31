package org.citra.citra_emu.viewmodel

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

class EmulationMenuViewModel : ViewModel() {
    private val _isDrawerOpen = MutableStateFlow(false)
    val isDrawerOpen: StateFlow<Boolean> = _isDrawerOpen.asStateFlow()

    private val _isSaveStateMenuOpen = MutableStateFlow(false)
    val isSaveStateMenuOpen: StateFlow<Boolean> = _isSaveStateMenuOpen.asStateFlow()

    private val _isOverlayMenuOpen = MutableStateFlow(false)
    val isOverlayMenuOpen: StateFlow<Boolean> = _isOverlayMenuOpen.asStateFlow()

    private val _isAmiiboMenuOpen = MutableStateFlow(false)
    val isAmiiboMenuOpen: StateFlow<Boolean> = _isAmiiboMenuOpen.asStateFlow()

    private val _isLayoutMenuOpen = MutableStateFlow(false)
    val isLayoutMenuOpen: StateFlow<Boolean> = _isLayoutMenuOpen.asStateFlow()

    private val _isPaused = MutableStateFlow(false)
    val isPaused: StateFlow<Boolean> = _isPaused.asStateFlow()

    fun setDrawerOpen(open: Boolean) {
        _isDrawerOpen.value = open
    }

    fun setSaveStateMenuOpen(open: Boolean) {
        _isSaveStateMenuOpen.value = open
        if (open) _isDrawerOpen.value = false
    }

    fun setOverlayMenuOpen(open: Boolean) {
        _isOverlayMenuOpen.value = open
        if (open) _isDrawerOpen.value = false
    }

    fun setAmiiboMenuOpen(open: Boolean) {
        _isAmiiboMenuOpen.value = open
        if (open) _isDrawerOpen.value = false
    }

    fun setLayoutMenuOpen(open: Boolean) {
        _isLayoutMenuOpen.value = open
        if (open) _isDrawerOpen.value = false
    }

    fun setPaused(paused: Boolean) {
        _isPaused.value = paused
    }

    fun togglePause() {
        _isPaused.value = !_isPaused.value
    }

    fun closeAllMenus() {
        _isDrawerOpen.value = false
        _isSaveStateMenuOpen.value = false
        _isOverlayMenuOpen.value = false
        _isAmiiboMenuOpen.value = false
        _isLayoutMenuOpen.value = false
    }
}
