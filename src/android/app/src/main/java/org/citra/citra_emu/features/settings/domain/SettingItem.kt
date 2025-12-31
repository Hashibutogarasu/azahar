package org.citra.citra_emu.features.settings.domain
import com.google.gson.annotations.SerializedName
import java.io.Serializable
enum class SettingAction {
    CORE_SETTINGS,
    ARCTIC_BASE,
    INSTALL_CIA,
    SYSTEM_FILES,
    SHARE_LOG,
    GPU_DRIVER,
    USER_FOLDER,
    GAMES_FOLDER,
    THEME,
    ABOUT
}
data class SettingItem(
    val titleId: Int,
    val descriptionId: Int,
    val iconId: Int,
    val action: SettingAction
) : Serializable
