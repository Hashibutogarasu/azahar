import 'package:flutter/material.dart';

/// Tokens for the bottom navigation bar. [glass] produces the floating, blurred Azahar pill;
/// [flat] reproduces the original flush, opaque Material navigation bar. Both are laid out the
/// same way (an overlay positioned by [bottomMargin]), so a single widget can render either.
class AppNavigationBarTheme extends ThemeExtension<AppNavigationBarTheme> {
  const AppNavigationBarTheme({
    required this.backgroundColor,
    required this.blurSigma,
    required this.borderColor,
    required this.radius,
    required this.shadow,
    required this.activeIndicatorColor,
    required this.activeIndicatorRadius,
    required this.activeIndicatorSize,
    required this.activeIconColor,
    required this.inactiveIconColor,
    required this.activeLabelStyle,
    required this.inactiveLabelStyle,
    required this.barPadding,
    required this.barHeight,
    required this.bottomMargin,
    required this.horizontalMargin,
    required this.stretchToFullWidth,
  });

  final Color backgroundColor;
  final double blurSigma;
  final Color borderColor;
  final BorderRadius radius;
  final List<BoxShadow> shadow;
  final Color activeIndicatorColor;
  final BorderRadius activeIndicatorRadius;
  final Size activeIndicatorSize;
  final Color activeIconColor;
  final Color inactiveIconColor;
  final TextStyle activeLabelStyle;
  final TextStyle inactiveLabelStyle;
  final EdgeInsets barPadding;
  final double barHeight;
  final double bottomMargin;
  final double horizontalMargin;
  final bool stretchToFullWidth;

  factory AppNavigationBarTheme.glass(ColorScheme colorScheme) {
    return AppNavigationBarTheme(
      backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
      blurSigma: 24,
      borderColor: colorScheme.onSurface.withValues(alpha: 0.12),
      radius: BorderRadius.circular(9999),
      shadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.3), blurRadius: 24)],
      activeIndicatorColor: colorScheme.primaryContainer.withValues(alpha: 0.25),
      activeIndicatorRadius: BorderRadius.circular(9999),
      activeIndicatorSize: const Size(64, 32),
      activeIconColor: colorScheme.primary,
      inactiveIconColor: colorScheme.onSurfaceVariant,
      activeLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      inactiveLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      barPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      barHeight: 64,
      bottomMargin: 24,
      horizontalMargin: 0,
      stretchToFullWidth: false,
    );
  }

  factory AppNavigationBarTheme.flat(ColorScheme colorScheme) {
    return AppNavigationBarTheme(
      backgroundColor: colorScheme.surfaceContainer,
      blurSigma: 0,
      borderColor: Colors.transparent,
      radius: BorderRadius.zero,
      shadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 4)],
      activeIndicatorColor: colorScheme.secondaryContainer,
      activeIndicatorRadius: BorderRadius.circular(16),
      activeIndicatorSize: const Size(64, 32),
      activeIconColor: colorScheme.onSecondaryContainer,
      inactiveIconColor: colorScheme.onSurfaceVariant,
      activeLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      inactiveLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      barPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      barHeight: 80,
      bottomMargin: 0,
      horizontalMargin: 0,
      stretchToFullWidth: true,
    );
  }

  @override
  AppNavigationBarTheme copyWith({
    Color? backgroundColor,
    double? blurSigma,
    Color? borderColor,
    BorderRadius? radius,
    List<BoxShadow>? shadow,
    Color? activeIndicatorColor,
    BorderRadius? activeIndicatorRadius,
    Size? activeIndicatorSize,
    Color? activeIconColor,
    Color? inactiveIconColor,
    TextStyle? activeLabelStyle,
    TextStyle? inactiveLabelStyle,
    EdgeInsets? barPadding,
    double? barHeight,
    double? bottomMargin,
    double? horizontalMargin,
    bool? stretchToFullWidth,
  }) {
    return AppNavigationBarTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      blurSigma: blurSigma ?? this.blurSigma,
      borderColor: borderColor ?? this.borderColor,
      radius: radius ?? this.radius,
      shadow: shadow ?? this.shadow,
      activeIndicatorColor: activeIndicatorColor ?? this.activeIndicatorColor,
      activeIndicatorRadius: activeIndicatorRadius ?? this.activeIndicatorRadius,
      activeIndicatorSize: activeIndicatorSize ?? this.activeIndicatorSize,
      activeIconColor: activeIconColor ?? this.activeIconColor,
      inactiveIconColor: inactiveIconColor ?? this.inactiveIconColor,
      activeLabelStyle: activeLabelStyle ?? this.activeLabelStyle,
      inactiveLabelStyle: inactiveLabelStyle ?? this.inactiveLabelStyle,
      barPadding: barPadding ?? this.barPadding,
      barHeight: barHeight ?? this.barHeight,
      bottomMargin: bottomMargin ?? this.bottomMargin,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      stretchToFullWidth: stretchToFullWidth ?? this.stretchToFullWidth,
    );
  }

  @override
  AppNavigationBarTheme lerp(ThemeExtension<AppNavigationBarTheme>? other, double t) {
    if (other is! AppNavigationBarTheme) return this;
    return AppNavigationBarTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      blurSigma: blurSigma + (other.blurSigma - blurSigma) * t,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      radius: BorderRadius.lerp(radius, other.radius, t)!,
      shadow: BoxShadow.lerpList(shadow, other.shadow, t) ?? shadow,
      activeIndicatorColor: Color.lerp(activeIndicatorColor, other.activeIndicatorColor, t)!,
      activeIndicatorRadius:
          BorderRadius.lerp(activeIndicatorRadius, other.activeIndicatorRadius, t)!,
      activeIndicatorSize: Size.lerp(activeIndicatorSize, other.activeIndicatorSize, t)!,
      activeIconColor: Color.lerp(activeIconColor, other.activeIconColor, t)!,
      inactiveIconColor: Color.lerp(inactiveIconColor, other.inactiveIconColor, t)!,
      activeLabelStyle: TextStyle.lerp(activeLabelStyle, other.activeLabelStyle, t)!,
      inactiveLabelStyle: TextStyle.lerp(inactiveLabelStyle, other.inactiveLabelStyle, t)!,
      barPadding: EdgeInsets.lerp(barPadding, other.barPadding, t)!,
      barHeight: barHeight + (other.barHeight - barHeight) * t,
      bottomMargin: bottomMargin + (other.bottomMargin - bottomMargin) * t,
      horizontalMargin: horizontalMargin + (other.horizontalMargin - horizontalMargin) * t,
      stretchToFullWidth: t < 0.5 ? stretchToFullWidth : other.stretchToFullWidth,
    );
  }
}
