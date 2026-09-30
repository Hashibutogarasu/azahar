import 'package:flutter/material.dart';

import 'azahar/azahar_theme.dart';
import 'legacy/legacy_theme.dart';
import 'theme_style.dart';

/// Builds the app's [ThemeData], delegating to [AzaharTheme] or [LegacyTheme] depending on
/// [style]. Index `0` of [staticThemeColor] means "use the theme's own default palette" under
/// [ThemeStyle.azahar]; indices `1` and up select one of [AzaharTheme.staticThemeColors] (shifted
/// down by one). Under [ThemeStyle.legacy], [staticThemeColor] indexes [LegacyTheme.staticThemeColors]
/// directly, unchanged from the pre-Azahar behavior.
abstract final class AppTheme {
  static ThemeData light({
    required ThemeStyle style,
    int staticThemeColor = 0,
    bool materialYou = false,
    ColorScheme? dynamicScheme,
  }) {
    return switch (style) {
      ThemeStyle.azahar => AzaharTheme.light(
        staticThemeColor: staticThemeColor == 0 ? null : staticThemeColor - 1,
        materialYou: materialYou,
        dynamicScheme: dynamicScheme,
      ),
      ThemeStyle.legacy => LegacyTheme.light(
        staticThemeColor: staticThemeColor,
        materialYou: materialYou,
        dynamicScheme: dynamicScheme,
      ),
    };
  }

  static ThemeData dark({
    required ThemeStyle style,
    int staticThemeColor = 0,
    bool blackBackgrounds = false,
    bool materialYou = false,
    ColorScheme? dynamicScheme,
  }) {
    return switch (style) {
      ThemeStyle.azahar => AzaharTheme.dark(
        staticThemeColor: staticThemeColor == 0 ? null : staticThemeColor - 1,
        blackBackgrounds: blackBackgrounds,
        materialYou: materialYou,
        dynamicScheme: dynamicScheme,
      ),
      ThemeStyle.legacy => LegacyTheme.dark(
        staticThemeColor: staticThemeColor,
        blackBackgrounds: blackBackgrounds,
        materialYou: materialYou,
        dynamicScheme: dynamicScheme,
      ),
    };
  }
}
