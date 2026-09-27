import 'package:flutter/material.dart';

/// Tokens for the search bar. [glass] produces the translucent, blurred Azahar pill; [flat]
/// reproduces the original opaque rounded-card search bar.
class AppSearchBarTheme extends ThemeExtension<AppSearchBarTheme> {
  const AppSearchBarTheme({
    required this.fillColor,
    required this.blurSigma,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.radius,
    required this.height,
    required this.iconColor,
    required this.hintColor,
    required this.textStyle,
  });

  final Color fillColor;
  final double blurSigma;
  final Color borderColor;
  final Color focusedBorderColor;
  final BorderRadius radius;
  final double height;
  final Color iconColor;
  final Color hintColor;
  final TextStyle textStyle;

  factory AppSearchBarTheme.glass(ColorScheme colorScheme) {
    return AppSearchBarTheme(
      fillColor: colorScheme.onSurface.withValues(alpha: 0.04),
      blurSigma: 24,
      borderColor: colorScheme.onSurface.withValues(alpha: 0.1),
      focusedBorderColor: colorScheme.primaryContainer.withValues(alpha: 0.6),
      radius: BorderRadius.circular(9999),
      height: 44,
      iconColor: colorScheme.onSurfaceVariant,
      hintColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
      textStyle: TextStyle(color: colorScheme.onSurface, fontSize: 14),
    );
  }

  factory AppSearchBarTheme.flat(ColorScheme colorScheme) {
    return AppSearchBarTheme(
      fillColor: colorScheme.surfaceContainerHighest,
      blurSigma: 0,
      borderColor: Colors.transparent,
      focusedBorderColor: colorScheme.primary,
      radius: BorderRadius.circular(28),
      height: 56,
      iconColor: colorScheme.onSurfaceVariant,
      hintColor: colorScheme.onSurfaceVariant,
      textStyle: TextStyle(color: colorScheme.onSurface, fontSize: 16),
    );
  }

  @override
  AppSearchBarTheme copyWith({
    Color? fillColor,
    double? blurSigma,
    Color? borderColor,
    Color? focusedBorderColor,
    BorderRadius? radius,
    double? height,
    Color? iconColor,
    Color? hintColor,
    TextStyle? textStyle,
  }) {
    return AppSearchBarTheme(
      fillColor: fillColor ?? this.fillColor,
      blurSigma: blurSigma ?? this.blurSigma,
      borderColor: borderColor ?? this.borderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      radius: radius ?? this.radius,
      height: height ?? this.height,
      iconColor: iconColor ?? this.iconColor,
      hintColor: hintColor ?? this.hintColor,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  AppSearchBarTheme lerp(ThemeExtension<AppSearchBarTheme>? other, double t) {
    if (other is! AppSearchBarTheme) return this;
    return AppSearchBarTheme(
      fillColor: Color.lerp(fillColor, other.fillColor, t)!,
      blurSigma: blurSigma + (other.blurSigma - blurSigma) * t,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      focusedBorderColor: Color.lerp(focusedBorderColor, other.focusedBorderColor, t)!,
      radius: BorderRadius.lerp(radius, other.radius, t)!,
      height: height + (other.height - height) * t,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      hintColor: Color.lerp(hintColor, other.hintColor, t)!,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
    );
  }
}
