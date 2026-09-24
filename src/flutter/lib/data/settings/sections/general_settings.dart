import '../../../i18n/translations.g.dart';
import '../../../routing/app_routes.dart';
import '../emulator_setting_key.dart';
import '../settings_item.dart';

abstract final class GeneralSettingKeys {
  static const useFrameLimit = IntBoolKey('Renderer', 'use_frame_limit', true);
  static const frameLimit = IntKey('Renderer', 'frame_limit', 100);
}

List<SettingsItem> buildGeneralSettingsItems(Translations t) {
  return [
    SettingsItem.switch_(
      title: t.settings.general.frameLimitEnable,
      description: t.settings.general.frameLimitEnableDescription,
      setting: GeneralSettingKeys.useFrameLimit,
    ),
    SettingsItem.slider(
      title: t.settings.general.frameLimitSlider,
      description: t.settings.general.frameLimitSliderDescription,
      setting: GeneralSettingKeys.frameLimit,
      min: 1,
      max: 200,
      units: '%',
    ),
    SettingsItem.submenu(
      title: t.settings.general.media,
      description: t.settings.general.mediaDescription,
      onTap: (context) => const OptionsMediaSettingsRoute().push(context),
    ),
  ];
}
