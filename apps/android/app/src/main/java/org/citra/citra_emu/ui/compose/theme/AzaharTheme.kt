// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.compose.theme

import android.content.Context
import android.content.res.Configuration
import androidx.annotation.AttrRes
import androidx.compose.material3.ColorScheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalContext
import com.google.android.material.color.MaterialColors
import com.google.android.material.R as MaterialR

/**
 * Applies a Material3 [MaterialTheme] whose [ColorScheme] mirrors the host
 * Activity's already-resolved XML theme (one of the static color presets,
 * Material You dynamic color, and dark/light or black-background mode, all
 * applied by `ThemeUtil.setTheme` before the Activity's content is set).
 *
 * Reading the resolved `?attr/colorPrimary`-style attributes keeps Compose
 * screens in sync with the existing theme picker without duplicating its
 * selection logic.
 */
@Composable
fun AzaharTheme(content: @Composable () -> Unit) {
    val context = LocalContext.current
    val colorScheme = remember(context) { context.toComposeColorScheme() }
    MaterialTheme(colorScheme = colorScheme, content = content)
}

private fun Context.toComposeColorScheme(): ColorScheme {
    fun attrColor(@AttrRes attr: Int): Color =
        Color(MaterialColors.getColor(this, attr, Color.Black.toArgb()))

    val isNightMode = (resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK) ==
        Configuration.UI_MODE_NIGHT_YES
    val base = if (isNightMode) darkColorScheme() else lightColorScheme()

    return base.copy(
        primary = attrColor(MaterialR.attr.colorPrimary),
        onPrimary = attrColor(MaterialR.attr.colorOnPrimary),
        primaryContainer = attrColor(MaterialR.attr.colorPrimaryContainer),
        onPrimaryContainer = attrColor(MaterialR.attr.colorOnPrimaryContainer),
        secondary = attrColor(MaterialR.attr.colorSecondary),
        onSecondary = attrColor(MaterialR.attr.colorOnSecondary),
        secondaryContainer = attrColor(MaterialR.attr.colorSecondaryContainer),
        onSecondaryContainer = attrColor(MaterialR.attr.colorOnSecondaryContainer),
        tertiary = attrColor(MaterialR.attr.colorTertiary),
        onTertiary = attrColor(MaterialR.attr.colorOnTertiary),
        tertiaryContainer = attrColor(MaterialR.attr.colorTertiaryContainer),
        onTertiaryContainer = attrColor(MaterialR.attr.colorOnTertiaryContainer),
        background = attrColor(android.R.attr.colorBackground),
        onBackground = attrColor(MaterialR.attr.colorOnBackground),
        surface = attrColor(MaterialR.attr.colorSurface),
        onSurface = attrColor(MaterialR.attr.colorOnSurface),
        surfaceVariant = attrColor(MaterialR.attr.colorSurfaceVariant),
        onSurfaceVariant = attrColor(MaterialR.attr.colorOnSurfaceVariant),
        outline = attrColor(MaterialR.attr.colorOutline),
        error = attrColor(MaterialR.attr.colorError),
        onError = attrColor(MaterialR.attr.colorOnError)
    )
}
