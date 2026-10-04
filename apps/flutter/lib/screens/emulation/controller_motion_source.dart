import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import 'active_motion_source_provider.dart';
import 'controller_motion_provider.dart';
import 'emulation_focus_provider.dart';
import 'emulation_session_provider.dart';
import 'motion_input_source.dart';
import 'motion_scaler.dart';

/// Gives the values of the motion sensors built into a game controller to the emulation while
/// [activeMotionSourceProvider] chooses the controller and controller input goes to the running
/// game. It draws nothing.
///
/// A resting sample is sent when the controller stops being the source or the input leaves the
/// game, so that no tilt is left behind. A controller is held like a device in landscape, so its
/// axes are converted the same way.
class ControllerMotionSource extends ConsumerStatefulWidget {
  const ControllerMotionSource({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ControllerMotionSource> createState() =>
      _ControllerMotionSourceState();
}

class _ControllerMotionSourceState
    extends ConsumerState<ControllerMotionSource> {
  static const int _landscapeRotation = 1;

  late final EmulationSessionNotifier _session;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _session = ref.read(emulationSessionProvider.notifier);
    ref.listenManual(controllerMotionProvider, (_, next) {
      final sample = next.value;
      if (sample != null) _onSample(sample);
    });
    ref.listenManual(activeMotionSourceProvider, (_, kind) {
      if (kind != MotionSourceKind.controller) _sendRest();
    });
  }

  @override
  void dispose() {
    _sendRest();
    super.dispose();
  }

  void _sendRest() {
    if (!_sent) return;
    _sent = false;
    _session.sendMotion(accel: MotionScaler.restAccel, gyro: Vec3.zero);
  }

  void _onSample(({Vec3 accel, Vec3 gyro}) sample) {
    if (ref.read(activeMotionSourceProvider) != MotionSourceKind.controller) {
      return;
    }
    final state = ref.read(emulationSessionProvider);
    if (!ref.read(emulationFocusProvider).isGameFocused ||
        !state.emulationStarted ||
        state.isPaused) {
      _sendRest();
      return;
    }
    final accel = MotionScaler.accelFromSensor(
      MotionInputSource.transformAxes(sample.accel, _landscapeRotation),
    );
    final gyro = MotionScaler.gyroFromSensor(
      MotionInputSource.transformAxes(sample.gyro, _landscapeRotation),
    );
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
