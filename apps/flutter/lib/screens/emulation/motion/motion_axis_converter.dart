import 'package:azahar_for_flutter/azahar_for_flutter.dart';

/// Converts the samples of one kind of motion sensor, in the axes that sensor reports them in, to
/// the axes of the console. Each kind of sensor has its own reference frame, so each has its own
/// implementation.
abstract interface class MotionAxisConverter {
  /// Converts a raw sensor vector to the axes of the console, keeping its units.
  Vec3 toConsoleAxes(Vec3 raw);
}
