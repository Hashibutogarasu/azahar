import 'dart:async';

import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';

/// The samples of the motion sensors built into a connected game controller, in m/s² and rad/s.
/// The sensors are only read while this provider is listened to.
final controllerMotionProvider =
    StreamProvider.autoDispose<({Vec3 accel, Vec3 gyro})>(
      (ref) => AppServices.nativeBridge.controllerMotion(),
    );

/// Whether a connected game controller is reporting its motion sensors.
final controllerMotionAvailableProvider =
    NotifierProvider.autoDispose<ControllerMotionAvailabilityNotifier, bool>(
      ControllerMotionAvailabilityNotifier.new,
    );

/// Becomes true when a sample arrives from [controllerMotionProvider], and false again once no
/// sample has arrived for [timeout], such as after the controller was disconnected.
class ControllerMotionAvailabilityNotifier extends Notifier<bool> {
  static const Duration timeout = Duration(seconds: 1);

  Timer? _timer;

  @override
  bool build() {
    ref.onDispose(() => _timer?.cancel());
    ref.listen(controllerMotionProvider, (_, next) {
      if (!next.hasValue) return;
      _timer?.cancel();
      _timer = Timer(timeout, () {
        if (ref.mounted) state = false;
      });
      if (!state) state = true;
    });
    return false;
  }
}
