import '../../../settings/emulator_setting_key.dart';
import '../../../settings/sections/graphics_settings.dart';
import 'bool_key_emulator_setting.dart';

/// Whether shaders are compiled in the background. Compiling them on the render thread instead
/// stalls the emulation, which costs more.
class AsyncShadersSetting extends BoolKeyEmulatorSetting {
  const AsyncShadersSetting();

  @override
  IntBoolKey get key => GraphicsSettingKeys.asyncShaders;

  @override
  double get weightIndex => 0.05;

  @override
  double weightFactor(bool value) => value ? 0.0 : 1.0;
}
