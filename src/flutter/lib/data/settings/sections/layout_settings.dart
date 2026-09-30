import '../emulator_setting_key.dart';

abstract final class LayoutSettingKeys {
  static const screenOrientation = IntKey('Layout', 'screen_orientation', 2);
}

abstract final class CustomLandscapeLayoutSettingKeys {
  static const topX = IntKey('Layout', 'custom_top_x', 0);
  static const topY = IntKey('Layout', 'custom_top_y', 0);
  static const topWidth = IntKey('Layout', 'custom_top_width', 800);
  static const topHeight = IntKey('Layout', 'custom_top_height', 480);
  static const bottomX = IntKey('Layout', 'custom_bottom_x', 80);
  static const bottomY = IntKey('Layout', 'custom_bottom_y', 480);
  static const bottomWidth = IntKey('Layout', 'custom_bottom_width', 640);
  static const bottomHeight = IntKey('Layout', 'custom_bottom_height', 480);
}

abstract final class CustomPortraitLayoutSettingKeys {
  static const topX = IntKey('Layout', 'custom_portrait_top_x', 0);
  static const topY = IntKey('Layout', 'custom_portrait_top_y', 0);
  static const topWidth = IntKey('Layout', 'custom_portrait_top_width', 800);
  static const topHeight = IntKey('Layout', 'custom_portrait_top_height', 480);
  static const bottomX = IntKey('Layout', 'custom_portrait_bottom_x', 80);
  static const bottomY = IntKey('Layout', 'custom_portrait_bottom_y', 480);
  static const bottomWidth = IntKey(
    'Layout',
    'custom_portrait_bottom_width',
    640,
  );
  static const bottomHeight = IntKey(
    'Layout',
    'custom_portrait_bottom_height',
    480,
  );
}
