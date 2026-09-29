import 'package:flutter/material.dart';

/// Material 3 color roles for the Azahar glassmorphic theme.
abstract final class AppGlassPalette {
  static const Color _seed = Color(0xFFFFABED);

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFABED),
    onPrimary: Color(0xFF5D0057),
    primaryContainer: Color(0xFFF07DDE),
    onPrimaryContainer: Color(0xFF71006A),
    secondary: Color(0xFFEFB5E0),
    onSecondary: Color(0xFF4A2144),
    secondaryContainer: Color(0xFF663A5E),
    onSecondaryContainer: Color(0xFFDFA7D1),
    tertiary: Color(0xFFA6D648),
    onTertiary: Color(0xFF243600),
    tertiaryContainer: Color(0xFF87B529),
    onTertiaryContainer: Color(0xFF2D4200),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF121317),
    onSurface: Color(0xFFE3E2E7),
    surfaceDim: Color(0xFF121317),
    surfaceBright: Color(0xFF38393D),
    surfaceContainerLowest: Color(0xFF0D0E12),
    surfaceContainerLow: Color(0xFF1A1B20),
    surfaceContainer: Color(0xFF1F1F24),
    surfaceContainerHigh: Color(0xFF292A2E),
    surfaceContainerHighest: Color(0xFF343439),
    onSurfaceVariant: Color(0xFFD6C0CE),
    outline: Color(0xFF9F8B98),
    outlineVariant: Color(0xFF52424D),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE3E2E7),
    onInverseSurface: Color(0xFF2F3035),
    inversePrimary: Color(0xFF9B3290),
    surfaceTint: Color(0xFFFFABED),
    primaryFixed: Color(0xFFFFD7F3),
    primaryFixedDim: Color(0xFFFFABED),
    onPrimaryFixed: Color(0xFF390035),
    onPrimaryFixedVariant: Color(0xFF7E1576),
    secondaryFixed: Color(0xFFFFD7F3),
    secondaryFixedDim: Color(0xFFEFB5E0),
    onSecondaryFixed: Color(0xFF320C2E),
    onSecondaryFixedVariant: Color(0xFF63385B),
    tertiaryFixed: Color(0xFFC1F362),
    tertiaryFixedDim: Color(0xFFA6D648),
    onTertiaryFixed: Color(0xFF131F00),
    onTertiaryFixedVariant: Color(0xFF364E00),
  );

  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: Brightness.light,
  );
}
