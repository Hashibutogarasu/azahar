import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import 'motion_axis_converter.dart';

/// Converts the samples of the motion sensors built into a game controller, whose axes stay fixed
/// to the controller instead of turning with a screen, so the mapping never changes.
class ControllerMotionAxisConverter implements MotionAxisConverter {
  const ControllerMotionAxisConverter();

  @override
  Vec3 toConsoleAxes(Vec3 raw) => Vec3(-raw.y, -raw.z, raw.x);
}
