package org.citra.citra_emu.features.settings.ui
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import org.citra.citra_emu.features.settings.data.SettingsRepository
import org.citra.citra_emu.features.settings.domain.SettingAction
import org.citra.citra_emu.features.settings.domain.SettingItem
import org.citra.citra_emu.model.Game
class SettingsViewModel : ViewModel() {
    private val _settingsList = MutableStateFlow<List<SettingItem>>(emptyList())
    val settingsList: StateFlow<List<SettingItem>> = _settingsList.asStateFlow()
    private val _events = MutableSharedFlow<SettingsEvent>()
    val events: SharedFlow<SettingsEvent> = _events.asSharedFlow()
    init {
        loadSettings()
    }
    private fun loadSettings() {
        _settingsList.value = SettingsRepository.settingsList
    }
    fun onSettingClicked(item: SettingItem) {
        viewModelScope.launch {
            when (item.action) {
                SettingAction.CORE_SETTINGS -> _events.emit(SettingsEvent.NavigateToCoreSettings)
                SettingAction.ARCTIC_BASE -> _events.emit(SettingsEvent.OpenArcticBaseDialog)
                SettingAction.INSTALL_CIA -> _events.emit(SettingsEvent.LaunchCiaInstaller)
                SettingAction.SYSTEM_FILES -> _events.emit(SettingsEvent.NavigateToSystemFiles)
                SettingAction.SHARE_LOG -> _events.emit(SettingsEvent.ShareLog)
                SettingAction.GPU_DRIVER -> _events.emit(SettingsEvent.NavigateToDriverManager)
                SettingAction.USER_FOLDER -> _events.emit(SettingsEvent.SelectUserFolder)
                SettingAction.GAMES_FOLDER -> _events.emit(SettingsEvent.SelectGamesFolder)
                SettingAction.THEME -> _events.emit(SettingsEvent.NavigateToThemeSettings)
                SettingAction.ABOUT -> _events.emit(SettingsEvent.NavigateToAbout)
            }
        }
    }
    fun onArcticBaseAddressEntered(address: String) {
        if (address.isNotEmpty()) {
            val game = Game(
                title = "Arctic Base", // Should act as title
                path = "articbase://$address",
                filename = ""
            )
            viewModelScope.launch {
                _events.emit(SettingsEvent.NavigateToEmulationActivity(game))
            }
        }
    }
}
