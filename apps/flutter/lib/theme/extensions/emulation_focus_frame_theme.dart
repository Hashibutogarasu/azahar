import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Tokens for the frame around the emulation screens, which is highlighted while controller input
/// goes to the running game. [glass] matches the Azahar look; [flat] matches the original plain
/// look.
class EmulationFocusFrameTheme
    extends ThemeExtension<EmulationFocusFrameTheme> {
  const EmulationFocusFrameTheme({
    required this.focusedColor,
    required this.width,
    required this.borderRadius,
  });

  final Color focusedColor;
  final double width;
  final BorderRadius borderRadius;

  factory EmulationFocusFrameTheme.glass(ColorScheme colorScheme) {
    return EmulationFocusFrameTheme(
      focusedColor: colorScheme.primary,
      width: 3,
      borderRadius: BorderRadius.circular(6),
    );
  }

  factory EmulationFocusFrameTheme.flat(ColorScheme colorScheme) {
    return EmulationFocusFrameTheme(
      focusedColor: colorScheme.primary,
      width: 2,
      borderRadius: BorderRadius.zero,
    );
  }

  @override
  EmulationFocusFrameTheme copyWith({
    Color? focusedColor,
    double? width,
    BorderRadius? borderRadius,
  }) {
    return EmulationFocusFrameTheme(
      focusedColor: focusedColor ?? this.focusedColor,
      width: width ?? this.width,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  EmulationFocusFrameTheme lerp(
    ThemeExtension<EmulationFocusFrameTheme>? other,
    double t,
  ) {
    if (other is! EmulationFocusFrameTheme) return this;
    return EmulationFocusFrameTheme(
      focusedColor: Color.lerp(focusedColor, other.focusedColor, t)!,
      width: lerpDouble(width, other.width, t)!,
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
    );
  }
}
