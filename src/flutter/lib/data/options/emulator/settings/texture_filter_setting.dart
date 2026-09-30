import '../../../settings/emulator_setting_key.dart';
import '../../../settings/sections/graphics_settings.dart';
import 'int_key_emulator_setting.dart';

/// The filter that upscales textures: 0 is none, and the numbers above it are increasingly costly
/// filters.
class TextureFilterSetting extends IntKeyEmulatorSetting {
  const TextureFilterSetting();

  static const _costs = <int, double>{
    0: 0.0,
    1: 1.0,
    2: 0.3,
    3: 0.5,
    4: 0.9,
    5: 0.8,
  };

  @override
  IntKey get key => GraphicsSettingKeys.textureFilter;

  @override
  double get weightIndex => 0.10;

  @override
  double weightFactor(int value) => _costs[value] ?? 0.0;
}
