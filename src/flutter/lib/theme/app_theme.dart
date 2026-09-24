import 'package:flutter/material.dart';

abstract final class AppTheme {
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
    return ThemeData(useMaterial3: true, colorScheme: colorScheme);
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
    return ThemeData(
      useMaterial3: true,
      colorScheme: blackBackgrounds
          ? colorScheme.copyWith(surface: Colors.black)
          : colorScheme,
      scaffoldBackgroundColor: blackBackgrounds ? Colors.black : null,
    );
  }
}
