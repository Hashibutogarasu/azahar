package org.citra.citra_emu.features.settings.ui
import org.citra.citra_emu.model.Game
sealed class SettingsEvent {
    object NavigateToCoreSettings : SettingsEvent()
    object OpenArcticBaseDialog : SettingsEvent()
    data class NavigateToEmulationActivity(val game: Game) : SettingsEvent()
    object LaunchCiaInstaller : SettingsEvent()
    object NavigateToSystemFiles : SettingsEvent()
    object ShareLog : SettingsEvent()
    object NavigateToDriverManager : SettingsEvent()
    object SelectUserFolder : SettingsEvent()
    object SelectGamesFolder : SettingsEvent()
    object NavigateToThemeSettings : SettingsEvent()
    object NavigateToAbout : SettingsEvent()
}
