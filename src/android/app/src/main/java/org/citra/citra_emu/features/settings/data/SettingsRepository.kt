package org.citra.citra_emu.features.settings.data
import org.citra.citra_emu.R
import org.citra.citra_emu.features.settings.domain.SettingAction
import org.citra.citra_emu.features.settings.domain.SettingItem
object SettingsRepository {
    // In a real app, this could be loaded from a JSON file using Gson
    val settingsList = listOf(
        SettingItem(
            R.string.grid_menu_core_settings,
            R.string.settings_description,
            R.drawable.ic_settings,
            SettingAction.CORE_SETTINGS
        ),
        SettingItem(
            R.string.artic_base_connect,
            R.string.artic_base_connect_description,
            R.drawable.ic_network,
            SettingAction.ARCTIC_BASE
        ),
        SettingItem(
            R.string.install_game_content,
            R.string.install_game_content_description,
            R.drawable.ic_install,
            SettingAction.INSTALL_CIA
        ),
        SettingItem(
            R.string.setup_system_files,
            R.string.setup_system_files_description,
            R.drawable.ic_system_update,
            SettingAction.SYSTEM_FILES
        ),
        SettingItem(
            R.string.share_log,
            R.string.share_log_description,
            R.drawable.ic_share,
            SettingAction.SHARE_LOG
        ),
        SettingItem(
            R.string.gpu_driver_manager,
            R.string.install_gpu_driver_description,
            R.drawable.ic_install_driver,
            SettingAction.GPU_DRIVER
        ),
        SettingItem(
            R.string.select_citra_user_folder,
            R.string.select_citra_user_folder_home_description,
            R.drawable.ic_home,
            SettingAction.USER_FOLDER
        ),
        SettingItem(
            R.string.select_games_folder,
            R.string.select_games_folder_description,
            R.drawable.ic_add,
            SettingAction.GAMES_FOLDER
        ),
        SettingItem(
            R.string.preferences_theme,
            R.string.theme_and_color_description,
            R.drawable.ic_palette,
            SettingAction.THEME
        ),
        SettingItem(
            R.string.about,
            R.string.about_description,
            R.drawable.ic_info_outline,
            SettingAction.ABOUT
        )
    )
}
