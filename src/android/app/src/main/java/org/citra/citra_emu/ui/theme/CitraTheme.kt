package org.citra.citra_emu.ui.theme
import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import androidx.appcompat.app.AppCompatDelegate
import androidx.preference.PreferenceManager
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.features.settings.model.Settings
import org.citra.citra_emu.ui.theme.color_schemes.*
import androidx.compose.runtime.remember
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.Color
@Composable
fun CitraTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val preferences = PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
    val themeMode = preferences.getInt(Settings.PREF_THEME_MODE, AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM)
    val useMaterialYou = preferences.getBoolean(Settings.PREF_MATERIAL_YOU, false)
    val useBlackBackgrounds = preferences.getBoolean(Settings.PREF_BLACK_BACKGROUNDS, false)
    val themeIndex = preferences.getInt(Settings.PREF_STATIC_THEME_COLOR, 0)
    val isDarkTheme = when (themeMode) {
        AppCompatDelegate.MODE_NIGHT_YES -> true
        AppCompatDelegate.MODE_NIGHT_NO -> false
        else -> isSystemInDarkTheme()
    }
    val context = LocalContext.current
    var colorScheme = when {
        useMaterialYou && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            if (isDarkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }
        else -> {
             // Fallback to static themes
             val selectedScheme = when(themeIndex) {
                 0 -> BlueColorScheme
                 1 -> CyanColorScheme
                 2 -> RedColorScheme
                 3 -> GreenColorScheme
                 4 -> YellowColorScheme
                 5 -> OrangeColorScheme
                 6 -> VioletColorScheme
                 7 -> PinkColorScheme
                 8 -> GrayColorScheme
                 else -> BlueColorScheme
             }
             if (isDarkTheme) selectedScheme.darkScheme else selectedScheme.lightScheme
        }
    }
    if (isDarkTheme && useBlackBackgrounds) {
        colorScheme = colorScheme.copy(surface = Color.Black, background = Color.Black)
    }
    MaterialTheme(
        colorScheme = colorScheme,
        content = content
    )
}
