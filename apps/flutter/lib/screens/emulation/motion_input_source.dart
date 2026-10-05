import 'dart:async';

import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../app_services.dart';
import 'active_motion_source_provider.dart';
import 'emulation_session_provider.dart';
import 'motion/device_motion_axis_converter.dart';
import 'motion_scaler.dart';

/// Reads the motion sensors of the device and gives their values to the emulation, in place of
/// the core reading the sensors itself. It draws nothing.
///
/// The sensors are only read while [activeMotionSourceProvider] chooses the device, and values are
/// sent about every [sendPeriod] while the emulation is running and not paused. A resting sample
/// is sent when the device stops being the source, so that no tilt is left behind.
class MotionInputSource extends ConsumerStatefulWidget {
  const MotionInputSource({super.key, required this.child});

  final Widget child;

  /// How often the latest sample is sent.
  static const sendPeriod = Duration(milliseconds: 16);

  @override
  ConsumerState<MotionInputSource> createState() => _MotionInputSourceState();
}

class _MotionInputSourceState extends ConsumerState<MotionInputSource> {
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;
  Timer? _sendTimer;
  Vec3? _accel;
  Vec3? _gyro;
  Vec3? _gravity;
  bool? _landscape;
  DateTime _settleUntil = DateTime.fromMillisecondsSinceEpoch(0);
  final DeviceMotionAxisConverter _axes = DeviceMotionAxisConverter();

  static const double _gravitySmoothing = 0.1;
  static const Duration _settleDuration = Duration(seconds: 1);

  late final EmulationSessionNotifier _session;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _session = ref.read(emulationSessionProvider.notifier);
    ref.listenManual(activeMotionSourceProvider, (_, kind) {
      if (kind == MotionSourceKind.device) {
        _start();
      } else {
        _stop();
      }
    }, fireImmediately: true);
  }

  void _start() {
    if (_sendTimer != null) return;
    _accelSubscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_onAccel, onError: (_) {});
    _gyroSubscription = gyroscopeEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_onGyro, onError: (_) {});
    _sendTimer = Timer.periodic(MotionInputSource.sendPeriod, (_) => _send());
  }

  void _stop() {
    _sendTimer?.cancel();
    _sendTimer = null;
    _accelSubscription?.cancel();
    _accelSubscription = null;
    _gyroSubscription?.cancel();
    _gyroSubscription = null;
    _accel = null;
    _gyro = null;
    if (_sent) {
      _sent = false;
      _session.sendMotion(accel: MotionScaler.restAccel, gyro: Vec3.zero);
    }
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  void _updateRotation(Vec3 raw) {
    _gravity = _gravity == null
        ? raw
        : Vec3(
            _gravity!.x + (raw.x - _gravity!.x) * _gravitySmoothing,
            _gravity!.y + (raw.y - _gravity!.y) * _gravitySmoothing,
            _gravity!.z + (raw.z - _gravity!.z) * _gravitySmoothing,
          );
    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final now = DateTime.now();
    if (landscape != _landscape) {
      _landscape = landscape;
      _settleUntil = now.add(_settleDuration);
    }
    if (!now.isBefore(_settleUntil)) return;
    _axes.rotation = DeviceMotionAxisConverter.rotationFrom(
      _gravity!,
      landscape: landscape,
      previous: _axes.rotation,
    );
  }

  void _onAccel(AccelerometerEvent event) {
    final raw = Vec3(event.x, event.y, event.z);
    _updateRotation(raw);
    _accel = MotionScaler.accelFromSensor(_axes.toConsoleAxes(raw));
  }

  void _onGyro(GyroscopeEvent event) {
    _gyro = MotionScaler.gyroFromSensor(
      _axes.toConsoleAxes(Vec3(event.x, event.y, event.z)),
    );
  }

  void _send() {
    final accel = _accel;
    final gyro = _gyro;
    if (accel == null || gyro == null) return;
    final state = ref.read(emulationSessionProvider);
    if (!state.emulationStarted || state.isPaused) return;
    _session.sendMotion(
      accel: accel,
      gyro: MotionScaler.scaleGyro(
        gyro,
        AppServices.emulatorSettingsRepository,
      ),
    );
    _sent = true;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
