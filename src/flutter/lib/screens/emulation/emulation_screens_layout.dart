import 'dart:math';

import 'package:flutter/widgets.dart';

/// Sizes and arrangement of the 3DS top and bottom screens for a given available area.
///
/// In portrait both screens share the same width and are stacked vertically; in landscape they
/// share the same height and are placed side by side. The shared dimension is scaled so the pair
/// fits the available area without cropping while keeping each screen's own aspect ratio.
class EmulationScreensLayout {
  const EmulationScreensLayout._({
    required this.direction,
    required this.topScreen,
    required this.bottomScreen,
  });

  /// Builds the layout that fits the pair of screens into [available].
  factory EmulationScreensLayout.fit(Size available, {bool isDesktop = false}) {
    final direction = isDesktop
        ? Axis.vertical
        : (available.width > available.height ? Axis.horizontal : Axis.vertical);
    final bottomAspect = _bottomScreenWidth / _bottomScreenHeight;

    final double zoom;
    if (direction == Axis.horizontal) {
      final combinedWidth = _topScreenWidth + _topScreenHeight * bottomAspect;
      zoom = min(
        available.width / combinedWidth,
        available.height / _topScreenHeight,
      );
    } else {
      final combinedHeight = _topScreenHeight + _topScreenWidth / bottomAspect;
      zoom = min(
        available.width / _topScreenWidth,
        available.height / combinedHeight,
      );
    }

    final topScreen = Size(zoom * _topScreenWidth, zoom * _topScreenHeight);
    final bottomScreen = direction == Axis.horizontal
        ? Size(topScreen.height * bottomAspect, topScreen.height)
        : Size(topScreen.width, topScreen.width / bottomAspect);

    return EmulationScreensLayout._(
      direction: direction,
      topScreen: topScreen,
      bottomScreen: bottomScreen,
    );
  }

  static const double _topScreenWidth = 400;
  static const double _topScreenHeight = 240;
  static const double _bottomScreenWidth = 320;
  static const double _bottomScreenHeight = 240;

  final Axis direction;
  final Size topScreen;
  final Size bottomScreen;
}
