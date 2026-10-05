import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import 'motion_axis_converter.dart';

/// Converts the samples of the motion sensors of the device the app runs on, whose axes turn with
/// the screen, for the current [rotation] in quarter turns counter-clockwise from portrait.
class DeviceMotionAxisConverter implements MotionAxisConverter {
  DeviceMotionAxisConverter();

  int rotation = 0;

  @override
  Vec3 toConsoleAxes(Vec3 raw) {
    return switch (rotation) {
      1 => Vec3(raw.y, raw.z, raw.x),
      2 => Vec3(raw.x, raw.z, -raw.y),
      3 => Vec3(-raw.y, raw.z, -raw.x),
      _ => Vec3(-raw.x, raw.z, raw.y),
    };
  }

  /// Works out the screen rotation from the direction of gravity, keeping [previous] while the
  /// device lies too flat to tell.
  static int rotationFrom(
    Vec3 rawAccel, {
    required bool landscape,
    required int previous,
  }) {
    const threshold = 3.0;
    if (landscape) {
      if (rawAccel.x.abs() < threshold) return previous;
      return rawAccel.x > 0 ? 1 : 3;
    }
    if (rawAccel.y.abs() < threshold) return previous;
    return rawAccel.y > 0 ? 0 : 2;
  }
}
