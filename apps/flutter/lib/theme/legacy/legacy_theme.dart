import 'package:flutter/material.dart';

import '../extensions/app_navigation_bar_theme.dart';
import '../extensions/app_search_bar_theme.dart';
import '../extensions/app_toggle_switch_theme.dart';
import '../extensions/background_blob_theme.dart';
import '../extensions/emulation_focus_frame_theme.dart';
import '../extensions/game_card_theme.dart';
import '../extensions/gamepad_notification_bar_theme.dart';
import '../extensions/glass_surface_theme.dart';
import '../extensions/settings_list_item_theme.dart';

/// The original, pre-Azahar theme: a plain Material 3 look built on [ColorScheme.fromSeed],
/// with every shared widget's [ThemeExtension] set to its flat, opaque token values.
abstract final class LegacyTheme {
  static const List<Color> staticThemeColors = [
    Colors.blue,
    Colors.cyan,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.deepPurple,
    Colors.pink,
    Colors.blueGrey,
  ];

  static ThemeData light({
    int staticThemeColor = 0,
    bool materialYou = false,
    ColorScheme? dynamicScheme,
  }) {
    final colorScheme = materialYou && dynamicScheme != null
        ? dynamicScheme
        : ColorScheme.fromSeed(
            seedColor: staticThemeColors[staticThemeColor],
            brightness: Brightness.light,
          );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: _extensions(colorScheme),
    );
  }

  static ThemeData dark({
    int staticThemeColor = 0,
    bool blackBackgrounds = false,
    bool materialYou = false,
    ColorScheme? dynamicScheme,
  }) {
    final colorScheme = materialYou && dynamicScheme != null
        ? dynamicScheme
        : ColorScheme.fromSeed(
            seedColor: staticThemeColors[staticThemeColor],
            brightness: Brightness.dark,
          );
    final effectiveScheme = blackBackgrounds
        ? colorScheme.copyWith(surface: Colors.black)
        : colorScheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: effectiveScheme,
      scaffoldBackgroundColor: blackBackgrounds ? Colors.black : null,
      extensions: _extensions(effectiveScheme),
    );
  }

  static List<ThemeExtension<dynamic>> _extensions(ColorScheme colorScheme) {
    return [
      GlassSurfaceTheme.flat(colorScheme),
      AppNavigationBarTheme.flat(colorScheme),
      AppSearchBarTheme.flat(colorScheme),
      SettingsListItemTheme.flat(colorScheme),
      AppToggleSwitchTheme.flat(colorScheme),
      GameCardTheme.flat(colorScheme),
      BackgroundBlobTheme.flat(colorScheme),
      GamepadNotificationBarTheme.flat(colorScheme),
      EmulationFocusFrameTheme.flat(colorScheme),
    ];
  }
}
