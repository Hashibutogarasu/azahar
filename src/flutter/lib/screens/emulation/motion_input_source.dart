import 'dart:async';
import 'dart:math';

import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../app_services.dart';
import '../../data/settings/emulator_setting_key.dart';
import 'emulation_session_provider.dart';

/// Reads the motion sensors of the device and gives their values to the emulation, in place of
/// the core reading the sensors itself. It draws nothing.
///
/// Values are sent about every [sendPeriod] while the emulation is running and not paused, and
/// only when the gyro input source setting is the device rather than a controller.
class MotionInputSource extends ConsumerStatefulWidget {
  const MotionInputSource({super.key, required this.child});

  final Widget child;

  /// How often the latest sample is sent.
  static const sendPeriod = Duration(milliseconds: 16);

  static const _gyroInputSource = IntKey('Controls', 'gyro_input_source', 0);
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

  static const double _standardGravity = 9.80665;
  static const int _deviceSource = 0;

  /// Converts a raw sensor vector, in the axes of the device, to the axes of the 3DS for a screen
  /// [rotation] in quarter turns counter-clockwise from portrait.
  @visibleForTesting
  static Vec3 transformAxes(Vec3 raw, int rotation) {
    return switch (rotation) {
      1 => Vec3(raw.y, raw.z, raw.x),
      2 => Vec3(raw.x, raw.z, -raw.y),
      3 => Vec3(-raw.y, raw.z, -raw.x),
      _ => Vec3(-raw.x, raw.z, raw.y),
    };
  }

  /// Works out the screen rotation from the direction of gravity, keeping [previous] while the
  /// device lies too flat to tell.
  @visibleForTesting
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

  @override
  ConsumerState<MotionInputSource> createState() => _MotionInputSourceState();
}

class _MotionInputSourceState extends ConsumerState<MotionInputSource> {
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;
  Timer? _sendTimer;
  Vec3? _accel;
  Vec3? _gyro;
  int _rotation = 0;

  @override
  void initState() {
    super.initState();
    _accelSubscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_onAccel, onError: (_) {});
    _gyroSubscription = gyroscopeEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_onGyro, onError: (_) {});
    _sendTimer = Timer.periodic(MotionInputSource.sendPeriod, (_) => _send());
  }

  @override
  void dispose() {
    _sendTimer?.cancel();
    _accelSubscription?.cancel();
    _gyroSubscription?.cancel();
    super.dispose();
  }

  void _onAccel(AccelerometerEvent event) {
    final raw = Vec3(event.x, event.y, event.z);
    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    _rotation = MotionInputSource.rotationFrom(
      raw,
      landscape: landscape,
      previous: _rotation,
    );
    final transformed = MotionInputSource.transformAxes(raw, _rotation);
    _accel = Vec3(
      transformed.x / -MotionInputSource._standardGravity,
      transformed.y / -MotionInputSource._standardGravity,
      transformed.z / -MotionInputSource._standardGravity,
    );
  }

  void _onGyro(GyroscopeEvent event) {
    final transformed = MotionInputSource.transformAxes(
      Vec3(event.x, event.y, event.z),
      _rotation,
    );
    const toDegrees = 180 / pi;
    _gyro = Vec3(
      transformed.x * toDegrees,
      transformed.y * toDegrees,
      transformed.z * toDegrees,
    );
  }

  void _send() {
    final accel = _accel;
    final gyro = _gyro;
    if (accel == null || gyro == null) return;
    final state = ref.read(emulationSessionProvider);
    if (!state.emulationStarted || state.isPaused) return;
    final settings = AppServices.emulatorSettingsRepository;
    if (settings.readInt(MotionInputSource._gyroInputSource) !=
        MotionInputSource._deviceSource) {
      return;
    }
    final verticalSign = settings.readBool(MotionInputSource._invertVertical)
        ? -1.0
        : 1.0;
    final horizontalSign =
        settings.readBool(MotionInputSource._invertHorizontal) ? -1.0 : 1.0;
    final scaled = Vec3(
      gyro.x *
          settings.readFloat(MotionInputSource._sensitivityVertical) *
          verticalSign,
      gyro.y *
          settings.readFloat(MotionInputSource._sensitivityHorizontal) *
          horizontalSign,
      gyro.z,
    );
    ref
        .read(emulationSessionProvider.notifier)
        .sendMotion(accel: accel, gyro: scaled);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
