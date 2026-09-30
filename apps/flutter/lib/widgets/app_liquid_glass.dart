import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

/// A panel drawn as Liquid Glass, or as a flat [Material] when [blurSigma] is zero (Legacy theme).
///
/// Set [refract] for floating chrome to use a refracting [LiquidGlassLens]; otherwise the
/// shader-free [LiquidGlassLite] is used, which is safe inside scrollables.
class AppLiquidGlass extends StatelessWidget {
  const AppLiquidGlass({
    super.key,
    required this.borderRadius,
    required this.blurSigma,
    required this.fillColor,
    required this.borderColor,
    required this.child,
    this.refract = false,
    this.shadow = const [],
  });

  final BorderRadius borderRadius;
  final double blurSigma;
  final Color fillColor;
  final Color borderColor;
  final bool refract;
  final List<BoxShadow> shadow;
  final Widget child;

  static const double _maxCornerRadius = 32;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: borderRadius,
      boxShadow: shadow,
    );

    if (blurSigma <= 0) {
      return DecoratedBox(
        decoration: decoration,
        child: Material(
          color: fillColor,
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      );
    }

    final shape = LiquidGlassShape(
      cornerRadius: borderRadius.topLeft.x.clamp(0.0, _maxCornerRadius),
      borderColor: borderColor,
    );
    final blur = LiquidGlassBlur(sigmaX: blurSigma, sigmaY: blurSigma);
    final content = Material(
      type: MaterialType.transparency,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: child,
    );

    return DecoratedBox(
      decoration: decoration,
      child: refract
          ? LiquidGlassLens(
              style: LiquidGlassStyle(
                shape: shape,
                appearance: LiquidGlassAppearance(color: fillColor, blur: blur),
                refraction: const LiquidGlassRefraction(
                  distortion: 0.1,
                  distortionWidth: 24,
                ),
              ),
              child: content,
            )
          : LiquidGlassLite(
              shape: shape,
              blur: blur,
              color: fillColor,
              child: content,
            ),
    );
  }
}
