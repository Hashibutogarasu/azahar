import 'package:flutter/material.dart';

/// Tokens for a single settings list row (icon, title, subtitle, chevron, value text). [glass]
/// matches the Azahar look; [flat] reproduces the original plain Material row styling.
class SettingsListItemTheme extends ThemeExtension<SettingsListItemTheme> {
  const SettingsListItemTheme({
    required this.iconColor,
    required this.titleColor,
    required this.titleStyle,
    required this.subtitleColor,
    required this.subtitleStyle,
    required this.chevronColor,
    required this.valueTextColor,
    required this.valueTextStyle,
    required this.hoverColor,
    required this.activeColor,
    required this.rowRadius,
  });

  final Color iconColor;
  final Color titleColor;
  final TextStyle titleStyle;
  final Color subtitleColor;
  final TextStyle subtitleStyle;
  final Color chevronColor;
  final Color valueTextColor;
  final TextStyle valueTextStyle;
  final Color hoverColor;
  final Color activeColor;
  final BorderRadius rowRadius;

  factory SettingsListItemTheme.glass(ColorScheme colorScheme) {
    return SettingsListItemTheme(
      iconColor: colorScheme.outline,
      titleColor: colorScheme.onSurface,
      titleStyle: TextStyle(color: colorScheme.onSurface, fontSize: 15),
      subtitleColor: colorScheme.outline,
      subtitleStyle: TextStyle(color: colorScheme.outline, fontSize: 12),
      chevronColor: colorScheme.outline,
      valueTextColor: colorScheme.outline,
      valueTextStyle: TextStyle(color: colorScheme.outline, fontSize: 12),
      hoverColor: colorScheme.onSurface.withValues(alpha: 0.03),
      activeColor: colorScheme.onSurface.withValues(alpha: 0.06),
      rowRadius: BorderRadius.circular(8),
    );
  }

  factory SettingsListItemTheme.flat(ColorScheme colorScheme) {
    return SettingsListItemTheme(
      iconColor: colorScheme.onSurfaceVariant,
      titleColor: colorScheme.onSurface,
      titleStyle: TextStyle(color: colorScheme.onSurface, fontSize: 16),
      subtitleColor: colorScheme.onSurfaceVariant,
      subtitleStyle: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: 14,
      ),
      chevronColor: colorScheme.onSurfaceVariant,
      valueTextColor: colorScheme.onSurfaceVariant,
      valueTextStyle: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: 14,
      ),
      hoverColor: colorScheme.onSurface.withValues(alpha: 0.08),
      activeColor: colorScheme.onSurface.withValues(alpha: 0.12),
      rowRadius: BorderRadius.zero,
    );
  }

  @override
  SettingsListItemTheme copyWith({
    Color? iconColor,
    Color? titleColor,
    TextStyle? titleStyle,
    Color? subtitleColor,
    TextStyle? subtitleStyle,
    Color? chevronColor,
    Color? valueTextColor,
    TextStyle? valueTextStyle,
    Color? hoverColor,
    Color? activeColor,
    BorderRadius? rowRadius,
  }) {
    return SettingsListItemTheme(
      iconColor: iconColor ?? this.iconColor,
      titleColor: titleColor ?? this.titleColor,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      chevronColor: chevronColor ?? this.chevronColor,
      valueTextColor: valueTextColor ?? this.valueTextColor,
      valueTextStyle: valueTextStyle ?? this.valueTextStyle,
      hoverColor: hoverColor ?? this.hoverColor,
      activeColor: activeColor ?? this.activeColor,
      rowRadius: rowRadius ?? this.rowRadius,
    );
  }

  @override
  SettingsListItemTheme lerp(
    ThemeExtension<SettingsListItemTheme>? other,
    double t,
  ) {
    if (other is! SettingsListItemTheme) return this;
    return SettingsListItemTheme(
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      titleColor: Color.lerp(titleColor, other.titleColor, t)!,
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t)!,
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t)!,
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t)!,
      chevronColor: Color.lerp(chevronColor, other.chevronColor, t)!,
      valueTextColor: Color.lerp(valueTextColor, other.valueTextColor, t)!,
      valueTextStyle: TextStyle.lerp(valueTextStyle, other.valueTextStyle, t)!,
      hoverColor: Color.lerp(hoverColor, other.hoverColor, t)!,
      activeColor: Color.lerp(activeColor, other.activeColor, t)!,
      rowRadius: BorderRadius.lerp(rowRadius, other.rowRadius, t)!,
    );
  }
}
