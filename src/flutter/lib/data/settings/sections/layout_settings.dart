import '../../../i18n/translations.g.dart';
import '../../../routing/app_routes.dart';
import '../emulator_setting_key.dart';
import '../settings_item.dart';

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

List<SettingsItem> buildLayoutSettingsItems(Translations t) {
  final l = t.settings.layout;
  return [
    SettingsItem.singleChoice(
      title: l.screenOrientation,
      setting: LayoutSettingKeys.screenOrientation,
      choiceLabels: [
        l.screenOrientationAutoSensor,
        l.screenOrientationLandscape,
        l.screenOrientationLandscapeReverse,
        l.screenOrientationPortrait,
        l.screenOrientationPortraitReverse,
      ],
      choiceValues: const [2, 0, 8, 1, 9],
    ),
    SettingsItem.submenu(
      title: l.customLandscapeLayout,
      onTap: (context) =>
          const OptionsCustomLandscapeLayoutSettingsRoute().push(context),
    ),
    SettingsItem.submenu(
      title: l.customPortraitLayout,
      onTap: (context) =>
          const OptionsCustomPortraitLayoutSettingsRoute().push(context),
    ),
  ];
}

List<SettingsItem> buildCustomLandscapeLayoutItems(Translations t) {
  final l = t.settings.layout;
  return _buildCustomLayoutItems(
    t,
    topX: CustomLandscapeLayoutSettingKeys.topX,
    topY: CustomLandscapeLayoutSettingKeys.topY,
    topWidth: CustomLandscapeLayoutSettingKeys.topWidth,
    topHeight: CustomLandscapeLayoutSettingKeys.topHeight,
    bottomX: CustomLandscapeLayoutSettingKeys.bottomX,
    bottomY: CustomLandscapeLayoutSettingKeys.bottomY,
    bottomWidth: CustomLandscapeLayoutSettingKeys.bottomWidth,
    bottomHeight: CustomLandscapeLayoutSettingKeys.bottomHeight,
  )..insert(0, SettingsItem.header(title: l.customLandscapeLayout));
}

List<SettingsItem> buildCustomPortraitLayoutItems(Translations t) {
  final l = t.settings.layout;
  return _buildCustomLayoutItems(
    t,
    topX: CustomPortraitLayoutSettingKeys.topX,
    topY: CustomPortraitLayoutSettingKeys.topY,
    topWidth: CustomPortraitLayoutSettingKeys.topWidth,
    topHeight: CustomPortraitLayoutSettingKeys.topHeight,
    bottomX: CustomPortraitLayoutSettingKeys.bottomX,
    bottomY: CustomPortraitLayoutSettingKeys.bottomY,
    bottomWidth: CustomPortraitLayoutSettingKeys.bottomWidth,
    bottomHeight: CustomPortraitLayoutSettingKeys.bottomHeight,
  )..insert(0, SettingsItem.header(title: l.customPortraitLayout));
}

List<SettingsItem> _buildCustomLayoutItems(
  Translations t, {
  required IntKey topX,
  required IntKey topY,
  required IntKey topWidth,
  required IntKey topHeight,
  required IntKey bottomX,
  required IntKey bottomY,
  required IntKey bottomWidth,
  required IntKey bottomHeight,
}) {
  final l = t.settings.layout;
  return [
    SettingsItem.header(title: l.topScreen),
    SettingsItem.slider(
      title: l.positionX,
      setting: topX,
      min: 0,
      max: 4000,
      units: 'px',
    ),
    SettingsItem.slider(
      title: l.positionY,
      setting: topY,
      min: 0,
      max: 4000,
      units: 'px',
    ),
    SettingsItem.slider(
      title: l.width,
      setting: topWidth,
      min: 0,
      max: 4000,
      units: 'px',
    ),
    SettingsItem.slider(
      title: l.height,
      setting: topHeight,
      min: 0,
      max: 4000,
      units: 'px',
    ),
    SettingsItem.header(title: l.bottomScreen),
    SettingsItem.slider(
      title: l.positionX,
      setting: bottomX,
      min: 0,
      max: 4000,
      units: 'px',
    ),
    SettingsItem.slider(
      title: l.positionY,
      setting: bottomY,
      min: 0,
      max: 4000,
      units: 'px',
    ),
    SettingsItem.slider(
      title: l.width,
      setting: bottomWidth,
      min: 0,
      max: 4000,
      units: 'px',
    ),
    SettingsItem.slider(
      title: l.height,
      setting: bottomHeight,
      min: 0,
      max: 4000,
      units: 'px',
    ),
  ];
}
