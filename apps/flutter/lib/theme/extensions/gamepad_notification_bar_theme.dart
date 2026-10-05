import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Tokens for the bar that tells a controller was connected or disconnected. [glass] matches the
/// Azahar look; [flat] matches the original plain look.
class GamepadNotificationBarTheme
    extends ThemeExtension<GamepadNotificationBarTheme> {
  const GamepadNotificationBarTheme({
    required this.connectedBackgroundColor,
    required this.disconnectedBackgroundColor,
    required this.foregroundColor,
    required this.textStyle,
    required this.height,
    required this.displayDuration,
  });

  final Color connectedBackgroundColor;
  final Color disconnectedBackgroundColor;
  final Color foregroundColor;
  final TextStyle textStyle;
  final double height;
  final Duration displayDuration;

  static const Color _green = Color(0xFF2E7D32);
  static const Color _grey = Color(0xFF616161);

  factory GamepadNotificationBarTheme.glass(ColorScheme colorScheme) {
    return GamepadNotificationBarTheme(
      connectedBackgroundColor: _green.withValues(alpha: 0.9),
      disconnectedBackgroundColor: _grey.withValues(alpha: 0.9),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      height: 40,
      displayDuration: const Duration(seconds: 3),
    );
  }

  factory GamepadNotificationBarTheme.flat(ColorScheme colorScheme) {
    return const GamepadNotificationBarTheme(
      connectedBackgroundColor: _green,
      disconnectedBackgroundColor: _grey,
      foregroundColor: Colors.white,
      textStyle: TextStyle(color: Colors.white, fontSize: 14),
      height: 40,
      displayDuration: Duration(seconds: 3),
    );
  }

  @override
  GamepadNotificationBarTheme copyWith({
    Color? connectedBackgroundColor,
    Color? disconnectedBackgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    double? height,
    Duration? displayDuration,
  }) {
    return GamepadNotificationBarTheme(
      connectedBackgroundColor:
          connectedBackgroundColor ?? this.connectedBackgroundColor,
      disconnectedBackgroundColor:
          disconnectedBackgroundColor ?? this.disconnectedBackgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      textStyle: textStyle ?? this.textStyle,
      height: height ?? this.height,
      displayDuration: displayDuration ?? this.displayDuration,
    );
  }

  @override
  GamepadNotificationBarTheme lerp(
    ThemeExtension<GamepadNotificationBarTheme>? other,
    double t,
  ) {
    if (other is! GamepadNotificationBarTheme) return this;
    return GamepadNotificationBarTheme(
      connectedBackgroundColor: Color.lerp(
        connectedBackgroundColor,
        other.connectedBackgroundColor,
        t,
      )!,
      disconnectedBackgroundColor: Color.lerp(
        disconnectedBackgroundColor,
        other.disconnectedBackgroundColor,
        t,
      )!,
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t)!,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
      height: lerpDouble(height, other.height, t)!,
      displayDuration: t < 0.5 ? displayDuration : other.displayDuration,
    );
  }
}
