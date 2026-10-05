import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../data/platform_provider.dart';
import '../../data/settings/emulator_setting_key.dart';
import 'controller_motion_provider.dart';
import 'emulation_session_provider.dart';

/// Where the motion samples sent to the emulation come from: the sensors of the device the app
/// runs on, the sensors built into a game controller, or nothing when no chosen sensor exists.
enum MotionSourceKind { device, controller, none }

const _gyroInputSource = IntKey('Controls', 'gyro_input_source', 0);
const _gyroInputSourceController = 1;

/// The single source of the motion samples sent to the emulation. Only one source sends at a
/// time, because the core keeps only the latest sample and two sources would overwrite each other.
///
/// A controller that reports its motion sensors is always preferred; otherwise the gyro input
/// source setting decides. The setting is only read once the emulation has started, since the
/// emulator settings are loaded when it launches.
final activeMotionSourceProvider = Provider.autoDispose<MotionSourceKind>((
  ref,
) {
  if (!ref.watch(
    emulationSessionProvider.select((state) => state.emulationStarted),
  )) {
    return MotionSourceKind.none;
  }
  if (ref.watch(controllerMotionAvailableProvider)) {
    return MotionSourceKind.controller;
  }
  final setting = AppServices.emulatorSettingsRepository.readInt(
    _gyroInputSource,
  );
  if (setting == _gyroInputSourceController) return MotionSourceKind.controller;
  return ref.watch(isDesktopPlatformProvider)
      ? MotionSourceKind.none
      : MotionSourceKind.device;
});
