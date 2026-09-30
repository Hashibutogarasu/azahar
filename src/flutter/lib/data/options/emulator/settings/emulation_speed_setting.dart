import '../../../../app_services.dart';
import '../../../settings/sections/general_settings.dart';
import 'emulator_setting.dart';

/// The emulation speed as a fraction of the original speed, where 1.0 is 100%, limited to
/// [minSpeed]..[maxSpeed]. It is stored as whole percentage points of the frame limit.
class EmulationSpeedSetting extends EmulatorSetting<double> {
  const EmulationSpeedSetting();

  static const minSpeed = 0.01;
  static const maxSpeed = 2.0;

  @override
  double get weightIndex => 0.15;

  @override
  double weightFactor(double value) => (value / maxSpeed).clamp(0.0, 1.0);

  @override
  double read() =>
      AppServices.emulatorSettingsRepository.readInt(
        GeneralSettingKeys.frameLimit,
      ) /
      100;

  @override
  Future<void> write(double value) async {
    await AppServices.emulatorSettingsRepository.writeInt(
      GeneralSettingKeys.frameLimit,
      (value * 100).round(),
    );
    await AppServices.emulatorSettingsRepository.save();
  }
}
