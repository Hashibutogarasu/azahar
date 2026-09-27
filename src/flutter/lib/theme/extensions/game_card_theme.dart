import 'package:flutter/material.dart';

/// Tokens for a games/applications list row. [glass] matches the Azahar look; [flat]
/// reproduces the original plain outlined card row.
class GameCardTheme extends ThemeExtension<GameCardTheme> {
  const GameCardTheme({
    required this.iconBoxFillColor,
    required this.iconBoxBorderColor,
    required this.iconBoxRadius,
    required this.iconBoxSize,
    required this.iconColor,
    required this.titleColor,
    required this.titleStyle,
    required this.subtitleColor,
    required this.subtitleStyle,
    required this.invalidExtensionColor,
  });

  final Color iconBoxFillColor;
  final Color iconBoxBorderColor;
  final BorderRadius iconBoxRadius;
  final double iconBoxSize;
  final Color iconColor;
  final Color titleColor;
  final TextStyle titleStyle;
  final Color subtitleColor;
  final TextStyle subtitleStyle;
  final Color invalidExtensionColor;

  factory GameCardTheme.glass(ColorScheme colorScheme) {
    return GameCardTheme(
      iconBoxFillColor: colorScheme.onSurface.withValues(alpha: 0.05),
      iconBoxBorderColor: colorScheme.onSurface.withValues(alpha: 0.12),
      iconBoxRadius: BorderRadius.circular(12),
      iconBoxSize: 56,
      iconColor: colorScheme.primaryContainer,
      titleColor: colorScheme.onSurface,
      titleStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      subtitleColor: colorScheme.onSurface.withValues(alpha: 0.6),
      subtitleStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12),
      invalidExtensionColor: colorScheme.errorContainer,
    );
  }

  factory GameCardTheme.flat(ColorScheme colorScheme) {
    return GameCardTheme(
      iconBoxFillColor: Colors.transparent,
      iconBoxBorderColor: colorScheme.outline,
      iconBoxRadius: BorderRadius.circular(4),
      iconBoxSize: 75,
      iconColor: colorScheme.primaryContainer,
      titleColor: colorScheme.onSurface,
      titleStyle: TextStyle(color: colorScheme.onSurface, fontSize: 14),
      subtitleColor: colorScheme.onSurfaceVariant,
      subtitleStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
      invalidExtensionColor: colorScheme.errorContainer,
    );
  }

  @override
  GameCardTheme copyWith({
    Color? iconBoxFillColor,
    Color? iconBoxBorderColor,
    BorderRadius? iconBoxRadius,
    double? iconBoxSize,
    Color? iconColor,
    Color? titleColor,
    TextStyle? titleStyle,
    Color? subtitleColor,
    TextStyle? subtitleStyle,
    Color? invalidExtensionColor,
  }) {
    return GameCardTheme(
      iconBoxFillColor: iconBoxFillColor ?? this.iconBoxFillColor,
      iconBoxBorderColor: iconBoxBorderColor ?? this.iconBoxBorderColor,
      iconBoxRadius: iconBoxRadius ?? this.iconBoxRadius,
      iconBoxSize: iconBoxSize ?? this.iconBoxSize,
      iconColor: iconColor ?? this.iconColor,
      titleColor: titleColor ?? this.titleColor,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      invalidExtensionColor: invalidExtensionColor ?? this.invalidExtensionColor,
    );
  }

  @override
  GameCardTheme lerp(ThemeExtension<GameCardTheme>? other, double t) {
    if (other is! GameCardTheme) return this;
    return GameCardTheme(
      iconBoxFillColor: Color.lerp(iconBoxFillColor, other.iconBoxFillColor, t)!,
      iconBoxBorderColor: Color.lerp(iconBoxBorderColor, other.iconBoxBorderColor, t)!,
      iconBoxRadius: BorderRadius.lerp(iconBoxRadius, other.iconBoxRadius, t)!,
      iconBoxSize: iconBoxSize + (other.iconBoxSize - iconBoxSize) * t,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      titleColor: Color.lerp(titleColor, other.titleColor, t)!,
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t)!,
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t)!,
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t)!,
      invalidExtensionColor: Color.lerp(invalidExtensionColor, other.invalidExtensionColor, t)!,
    );
  }
}
