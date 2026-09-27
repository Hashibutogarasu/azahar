import 'package:flutter/material.dart';

/// Tokens for the pill toggle switch (replacement for the stock [Switch]). [glass] matches the
/// Azahar look; [flat] approximates the stock Material 3 [Switch] colors.
class AppToggleSwitchTheme extends ThemeExtension<AppToggleSwitchTheme> {
  const AppToggleSwitchTheme({
    required this.trackColorOn,
    required this.trackColorOff,
    required this.trackBorderColorOff,
    required this.thumbColorOn,
    required this.thumbColorOff,
    required this.trackSize,
    required this.thumbSize,
  });

  final Color trackColorOn;
  final Color trackColorOff;
  final Color trackBorderColorOff;
  final Color thumbColorOn;
  final Color thumbColorOff;
  final Size trackSize;
  final double thumbSize;

  factory AppToggleSwitchTheme.glass(ColorScheme colorScheme) {
    return AppToggleSwitchTheme(
      trackColorOn: colorScheme.primaryContainer,
      trackColorOff: colorScheme.onSurface.withValues(alpha: 0.1),
      trackBorderColorOff: colorScheme.onSurface.withValues(alpha: 0.1),
      thumbColorOn: colorScheme.surface,
      thumbColorOff: colorScheme.outline,
      trackSize: const Size(48, 24),
      thumbSize: 20,
    );
  }

  factory AppToggleSwitchTheme.flat(ColorScheme colorScheme) {
    return AppToggleSwitchTheme(
      trackColorOn: colorScheme.primary,
      trackColorOff: colorScheme.surfaceContainerHighest,
      trackBorderColorOff: colorScheme.outline,
      thumbColorOn: colorScheme.onPrimary,
      thumbColorOff: colorScheme.outline,
      trackSize: const Size(52, 32),
      thumbSize: 24,
    );
  }

  @override
  AppToggleSwitchTheme copyWith({
    Color? trackColorOn,
    Color? trackColorOff,
    Color? trackBorderColorOff,
    Color? thumbColorOn,
    Color? thumbColorOff,
    Size? trackSize,
    double? thumbSize,
  }) {
    return AppToggleSwitchTheme(
      trackColorOn: trackColorOn ?? this.trackColorOn,
      trackColorOff: trackColorOff ?? this.trackColorOff,
      trackBorderColorOff: trackBorderColorOff ?? this.trackBorderColorOff,
      thumbColorOn: thumbColorOn ?? this.thumbColorOn,
      thumbColorOff: thumbColorOff ?? this.thumbColorOff,
      trackSize: trackSize ?? this.trackSize,
      thumbSize: thumbSize ?? this.thumbSize,
    );
  }

  @override
  AppToggleSwitchTheme lerp(ThemeExtension<AppToggleSwitchTheme>? other, double t) {
    if (other is! AppToggleSwitchTheme) return this;
    return AppToggleSwitchTheme(
      trackColorOn: Color.lerp(trackColorOn, other.trackColorOn, t)!,
      trackColorOff: Color.lerp(trackColorOff, other.trackColorOff, t)!,
      trackBorderColorOff: Color.lerp(trackBorderColorOff, other.trackBorderColorOff, t)!,
      thumbColorOn: Color.lerp(thumbColorOn, other.thumbColorOn, t)!,
      thumbColorOff: Color.lerp(thumbColorOff, other.thumbColorOff, t)!,
      trackSize: Size.lerp(trackSize, other.trackSize, t)!,
      thumbSize: thumbSize + (other.thumbSize - thumbSize) * t,
    );
  }
}
