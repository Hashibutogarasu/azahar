import 'dart:math';

import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../data/settings/emulator_setting_key.dart';
import '../../data/settings/emulator_settings_repository.dart';

/// Converts the samples of a motion sensor to the units of the emulation and applies the gyro
/// sensitivity and inversion settings, whichever sensor they come from.
class MotionScaler {
  const MotionScaler._();

  static const Vec3 restAccel = Vec3(0, -1, 0);

  static const double _standardGravity = 9.80665;

  /// Converts an acceleration in m/s², already in the axes of the console, to the g units the
  /// emulation takes.
  static Vec3 accelFromSensor(Vec3 accel) => Vec3(
    accel.x / -_standardGravity,
    accel.y / -_standardGravity,
    accel.z / -_standardGravity,
  );

  /// Converts a rotation rate in rad/s, already in the axes of the console, to the degrees per
  /// second the emulation takes.
  static Vec3 gyroFromSensor(Vec3 gyro) {
    const toDegrees = 180 / pi;
    return Vec3(gyro.x * toDegrees, gyro.y * toDegrees, gyro.z * toDegrees);
  }

  static const _sensitivityVertical = ScaledFloatKey(
    'Controls',
    'gyro_sensitivity_vertical',
    1.0,
    100,
  );
  static const _sensitivityHorizontal = ScaledFloatKey(
    'Controls',
    'gyro_sensitivity_horizontal',
    1.0,
    100,
  );
  static const _invertVertical = IntBoolKey(
    'Controls',
    'invert_gyro_vertical',
    false,
  );
  static const _invertHorizontal = IntBoolKey(
    'Controls',
    'invert_gyro_horizontal',
    false,
  );

  /// Scales [gyro], in degrees per second in the axes of the console, by the sensitivity settings
  /// and flips the axes the settings invert.
  static Vec3 scaleGyro(Vec3 gyro, EmulatorSettingsRepository settings) {
    double sensitivity(ScaledFloatKey key) =>
        settings.readFloat(key) / key.scale;
    final verticalSign = settings.readBool(_invertVertical) ? -1.0 : 1.0;
    final horizontalSign = settings.readBool(_invertHorizontal) ? -1.0 : 1.0;
    return Vec3(
      gyro.x * sensitivity(_sensitivityVertical) * verticalSign,
      gyro.y * sensitivity(_sensitivityHorizontal) * horizontalSign,
      gyro.z,
    );
  }
}
