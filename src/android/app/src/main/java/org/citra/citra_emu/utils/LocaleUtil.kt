package org.citra.citra_emu.utils
import android.content.Context
import android.content.res.Configuration
import android.content.res.Resources
import androidx.appcompat.app.AppCompatDelegate
import androidx.core.os.ConfigurationCompat
import androidx.core.os.LocaleListCompat
import androidx.preference.PreferenceManager
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.features.settings.model.Settings
import java.util.Locale
object LocaleUtil {
    fun applyLocalizedContext(baseContext: Context): Context {
        try {
            val prefs = baseContext.getSharedPreferences(
                "${baseContext.packageName}_preferences",
                Context.MODE_PRIVATE
            )
            val language = prefs.getString(Settings.PREF_APP_LANGUAGE, "")
            if (language.isNullOrEmpty()) {
                return baseContext
            }
            val locale = Locale(language)
            Locale.setDefault(locale)
            val config = Configuration(baseContext.resources.configuration)
            config.setLocale(locale)
            config.setLayoutDirection(locale)
            return baseContext.createConfigurationContext(config)
        } catch (e: Exception) {
            e.printStackTrace()
            return baseContext
        }
    }
    fun updateConfig(context: Context) {
        val language = PreferenceManager.getDefaultSharedPreferences(context)
            .getString(Settings.PREF_APP_LANGUAGE, "")
        if (language.isNullOrEmpty()) {
            return
        }
        val locale = Locale(language)
        Locale.setDefault(locale)
        val resources: Resources = context.resources
        val config: Configuration = resources.configuration
        config.setLocale(locale)
        config.setLayoutDirection(locale)
        @Suppress("DEPRECATION")
        resources.updateConfiguration(config, resources.displayMetrics)
        // Also update AppCompatDelegate for good measure
        val localeList = LocaleListCompat.create(locale)
        AppCompatDelegate.setApplicationLocales(localeList)
    }
}
