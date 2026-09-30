import '../../../../app_services.dart';
import '../../../settings/emulator_setting_key.dart';
import 'emulator_setting.dart';

/// An [EmulatorSetting] stored as an integer under one emulator settings key.
abstract class IntKeyEmulatorSetting extends EmulatorSetting<int> {
  const IntKeyEmulatorSetting();

  /// The key the value is stored under.
  IntKey get key;

  @override
  int read() => AppServices.emulatorSettingsRepository.readInt(key);

  @override
  Future<void> write(int value) async {
    await AppServices.emulatorSettingsRepository.writeInt(key, value);
    await AppServices.emulatorSettingsRepository.save();
  }
}
