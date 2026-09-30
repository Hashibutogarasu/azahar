import '../../../settings/emulator_setting_key.dart';
import '../../../settings/sections/graphics_settings.dart';
import 'int_key_emulator_setting.dart';

/// The factor the 3DS screen resolution is multiplied by, from 1 (native) to 10. It affects the
/// weight of the emulation more than any other setting except the graphics API.
class InternalResolutionSetting extends IntKeyEmulatorSetting {
  const InternalResolutionSetting();

  static const maxFactor = 10;

  @override
  IntKey get key => GraphicsSettingKeys.resolutionFactor;

  @override
  double get weightIndex => 0.25;

  @override
  double weightFactor(int value) => (value / maxFactor).clamp(0.0, 1.0);
}
