import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// A panel drawn as Liquid Glass, or as a flat [Material] when [blurSigma] is zero (Legacy theme).
///
/// Set [refract] for floating chrome to use a refracting [LiquidGlass]; otherwise the
/// shader-free [FakeGlass] is used, which is safe inside scrollables.
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

    final shape = LiquidRoundedRectangle(
      borderRadius: borderRadius.topLeft.x.clamp(0.0, _maxCornerRadius),
      side: BorderSide(color: borderColor),
    );
    final settings = LiquidGlassSettings(
      glassColor: fillColor,
      blur: blurSigma,
    );
    final content = Material(
      type: MaterialType.transparency,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: child,
    );

    return DecoratedBox(
      decoration: decoration,
      child: refract
          ? LiquidGlass.withOwnLayer(
              shape: shape,
              settings: settings.copyWith(thickness: 24),
              child: content,
            )
          : FakeGlass(
              shape: shape,
              settings: settings,
              child: content,
            ),
    );
  }
}
