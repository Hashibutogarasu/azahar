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
import 'app_glass_palette.dart';

/// The glassmorphic Azahar theme: the fixed color palette plus every custom
/// [ThemeExtension] the Azahar-styled widgets read from.
abstract final class AzaharTheme {
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
    int? staticThemeColor,
    bool materialYou = false,
    ColorScheme? dynamicScheme,
  }) {
    return _themeData(
      brightness: Brightness.light,
      staticThemeColor: staticThemeColor,
      materialYou: materialYou,
      dynamicScheme: dynamicScheme,
    );
  }

  static ThemeData dark({
    int? staticThemeColor,
    bool blackBackgrounds = false,
    bool materialYou = false,
    ColorScheme? dynamicScheme,
  }) {
    return _themeData(
      brightness: Brightness.dark,
      staticThemeColor: staticThemeColor,
      blackBackgrounds: blackBackgrounds,
      materialYou: materialYou,
      dynamicScheme: dynamicScheme,
    );
  }

  static ThemeData _themeData({
    required Brightness brightness,
    int? staticThemeColor,
    bool blackBackgrounds = false,
    bool materialYou = false,
    ColorScheme? dynamicScheme,
  }) {
    final colorScheme = _resolveColorScheme(
      brightness: brightness,
      staticThemeColor: staticThemeColor,
      materialYou: materialYou,
      dynamicScheme: dynamicScheme,
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

  static ColorScheme _resolveColorScheme({
    required Brightness brightness,
    int? staticThemeColor,
    required bool materialYou,
    ColorScheme? dynamicScheme,
  }) {
    if (materialYou && dynamicScheme != null) return dynamicScheme;
    if (staticThemeColor != null) {
      return ColorScheme.fromSeed(
        seedColor: staticThemeColors[staticThemeColor],
        brightness: brightness,
      );
    }
    return switch (brightness) {
      Brightness.light => AppGlassPalette.lightColorScheme,
      Brightness.dark => AppGlassPalette.darkColorScheme,
    };
  }

  static List<ThemeExtension<dynamic>> _extensions(ColorScheme colorScheme) {
    return [
      GlassSurfaceTheme.glass(colorScheme),
      AppNavigationBarTheme.glass(colorScheme),
      AppSearchBarTheme.glass(colorScheme),
      SettingsListItemTheme.glass(colorScheme),
      AppToggleSwitchTheme.glass(colorScheme),
      GameCardTheme.glass(colorScheme),
      BackgroundBlobTheme.glass(colorScheme),
      GamepadNotificationBarTheme.glass(colorScheme),
      EmulationFocusFrameTheme.glass(colorScheme),
    ];
  }
}
