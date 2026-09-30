import 'package:flutter/foundation.dart';

import 'gamepad_axis.dart';
import 'gamepad_button.dart';
import 'vec3.dart';

/// One input given to, or reported by, the native gamepad interface.
///
/// It is exactly one of a button press or release ([button]), an analog stick position ([axis]),
/// or a motion sensor sample ([accel] and [gyro]); use [kind] to tell them apart.
@immutable
class GamePadContext {
  const GamePadContext.button(
    GamePadButton this.button, {
    required this.pressed,
  }) : axis = null,
       x = 0,
       y = 0,
       accel = null,
       gyro = null;

  const GamePadContext.axis(GamePadAxis this.axis, {this.x = 0, this.y = 0})
    : button = null,
      pressed = false,
      accel = null,
      gyro = null;

  const GamePadContext.motion({
    required Vec3 this.accel,
    required Vec3 this.gyro,
  }) : button = null,
       pressed = false,
       axis = null,
       x = 0,
       y = 0;

  final GamePadButton? button;

  /// Whether [button] is pressed (true) or released (false).
  final bool pressed;

  final GamePadAxis? axis;

  /// The horizontal position of [axis], from -1.0 (left) to 1.0 (right).
  final double x;

  /// The vertical position of [axis], from -1.0 (down) to 1.0 (up).
  final double y;

  /// The acceleration in g, present for a motion sample.
  final Vec3? accel;

  /// The angular velocity in degrees per second, present for a motion sample.
  final Vec3? gyro;

  GamePadKind get kind {
    if (button != null) return GamePadKind.button;
    if (axis != null) return GamePadKind.axis;
    return GamePadKind.motion;
  }

  Map<String, Object?> toMap() => switch (kind) {
    GamePadKind.button => {
      'kind': 'button',
      'code': button!.code,
      'pressed': pressed,
    },
    GamePadKind.axis => {'kind': 'axis', 'code': axis!.code, 'x': x, 'y': y},
    GamePadKind.motion => {
      'kind': 'motion',
      'accel': accel!.toList(),
      'gyro': gyro!.toList(),
    },
  };

  static GamePadContext fromMap(Map<Object?, Object?> map) {
    switch (map['kind']) {
      case 'button':
        final code = (map['code'] as num).toInt();
        return GamePadContext.button(
          GamePadButton.values.firstWhere((value) => value.code == code),
          pressed: map['pressed'] as bool,
        );
      case 'axis':
        final code = (map['code'] as num).toInt();
        return GamePadContext.axis(
          GamePadAxis.values.firstWhere((value) => value.code == code),
          x: (map['x'] as num).toDouble(),
          y: (map['y'] as num).toDouble(),
        );
      default:
        return GamePadContext.motion(
          accel: Vec3.fromList((map['accel'] as List).cast<Object?>()),
          gyro: Vec3.fromList((map['gyro'] as List).cast<Object?>()),
        );
    }
  }

  @override
  String toString() => 'GamePadContext(${toMap()})';
}

/// The kind of input a [GamePadContext] carries.
enum GamePadKind { button, axis, motion }
