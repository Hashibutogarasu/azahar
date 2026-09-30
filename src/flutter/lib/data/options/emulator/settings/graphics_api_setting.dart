import '../../../settings/emulator_setting_key.dart';
import '../../../settings/sections/graphics_settings.dart';
import 'int_key_emulator_setting.dart';

/// The graphics API the renderer uses: 1 is OpenGL ES and 2 is Vulkan. It affects the weight of
/// the emulation more than any other setting.
class GraphicsApiSetting extends IntKeyEmulatorSetting {
  const GraphicsApiSetting();

  static const openGles = 1;
  static const vulkan = 2;

  @override
  IntKey get key => GraphicsSettingKeys.graphicsApi;

  @override
  double get weightIndex => 0.35;

  @override
  double weightFactor(int value) => value == vulkan ? 0.6 : 1.0;
}
