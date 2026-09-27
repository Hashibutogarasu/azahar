import 'package:flutter/material.dart';

/// Panel tokens shared by search bars, cards, and grouped lists. [glass] produces the
/// translucent, blurred Azahar look; [flat] reproduces the original opaque Material panel.
class GlassSurfaceTheme extends ThemeExtension<GlassSurfaceTheme> {
  const GlassSurfaceTheme({
    required this.fillColor,
    required this.blurSigma,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.shadow,
    this.focusedBorderColor,
  });

  final Color fillColor;
  final double blurSigma;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final List<BoxShadow> shadow;
  final Color? focusedBorderColor;

  factory GlassSurfaceTheme.glass(ColorScheme colorScheme) {
    return GlassSurfaceTheme(
      fillColor: colorScheme.onSurface.withValues(alpha: 0.04),
      blurSigma: 24,
      borderColor: colorScheme.onSurface.withValues(alpha: 0.12),
      borderWidth: 1,
      borderRadius: BorderRadius.circular(16),
      shadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.2), blurRadius: 16)],
      focusedBorderColor: colorScheme.primaryContainer.withValues(alpha: 0.6),
    );
  }

  factory GlassSurfaceTheme.flat(ColorScheme colorScheme) {
    return GlassSurfaceTheme(
      fillColor: colorScheme.surfaceContainer,
      blurSigma: 0,
      borderColor: Colors.transparent,
      borderWidth: 0,
      borderRadius: BorderRadius.circular(12),
      shadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.08), blurRadius: 4)],
      focusedBorderColor: colorScheme.primary,
    );
  }

  @override
  GlassSurfaceTheme copyWith({
    Color? fillColor,
    double? blurSigma,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadow,
    Color? focusedBorderColor,
  }) {
    return GlassSurfaceTheme(
      fillColor: fillColor ?? this.fillColor,
      blurSigma: blurSigma ?? this.blurSigma,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      shadow: shadow ?? this.shadow,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
    );
  }

  @override
  GlassSurfaceTheme lerp(ThemeExtension<GlassSurfaceTheme>? other, double t) {
    if (other is! GlassSurfaceTheme) return this;
    return GlassSurfaceTheme(
      fillColor: Color.lerp(fillColor, other.fillColor, t)!,
      blurSigma: blurSigma + (other.blurSigma - blurSigma) * t,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      borderWidth: borderWidth + (other.borderWidth - borderWidth) * t,
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
      shadow: BoxShadow.lerpList(shadow, other.shadow, t) ?? shadow,
      focusedBorderColor: Color.lerp(focusedBorderColor, other.focusedBorderColor, t),
    );
  }
}
