import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color _seedColor = Color(0xFFB71C1C);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );
    return ThemeData(useMaterial3: true, colorScheme: colorScheme);
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );
    return ThemeData(useMaterial3: true, colorScheme: colorScheme);
  }
}
