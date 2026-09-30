import '../../../../app_services.dart';
import '../../../settings/emulator_setting_key.dart';
import 'emulator_setting.dart';

/// An [EmulatorSetting] stored as an on/off switch under one emulator settings key.
abstract class BoolKeyEmulatorSetting extends EmulatorSetting<bool> {
  const BoolKeyEmulatorSetting();

  /// The key the value is stored under.
  IntBoolKey get key;

  @override
  bool readCurrent() => AppServices.emulatorSettingsRepository.readBool(key);

  @override
  Future<void> writeCurrent(bool value) async {
    await AppServices.emulatorSettingsRepository.writeBool(key, value);
    await AppServices.emulatorSettingsRepository.save();
  }
}
