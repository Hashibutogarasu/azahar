import '../../../settings/emulator_setting_key.dart';
import '../../../settings/sections/graphics_settings.dart';
import 'bool_key_emulator_setting.dart';

/// Whether compiled shaders are kept on disk. Without the cache every shader is compiled again on
/// each run, which costs the most.
class ShaderCacheSetting extends BoolKeyEmulatorSetting {
  const ShaderCacheSetting();

  @override
  IntBoolKey get key => GraphicsSettingKeys.diskShaderCache;

  @override
  double get weightIndex => 0.05;

  @override
  double weightFactor(bool value) => value ? 0.0 : 1.0;
}
