import '../../../settings/emulator_setting_key.dart';
import '../../../settings/sections/graphics_settings.dart';
import 'bool_key_emulator_setting.dart';

/// Whether shaders are generated as SPIR-V, which is slower to build than the default.
class SpirvShaderGenSetting extends BoolKeyEmulatorSetting {
  const SpirvShaderGenSetting();

  @override
  IntBoolKey get key => GraphicsSettingKeys.spirvShaderGen;

  @override
  double get weightIndex => 0.05;

  @override
  double weightFactor(bool value) => value ? 1.0 : 0.0;
}
