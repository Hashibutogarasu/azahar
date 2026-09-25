import '../../../i18n/translations.g.dart';
import '../emulator_setting_key.dart';
import '../settings_item.dart';
import 'general_settings.dart';

abstract final class SystemSettingKeys {
  static const new3ds = IntBoolKey('System', 'is_new_3ds', true);
  static const lleApplets = IntBoolKey('System', 'lle_applets', true);
  static const requiredOnlineLleModules = IntBoolKey(
    'System',
    'enable_required_online_lle_modules',
    false,
  );
  static const emulatedRegion = IntKey('System', 'region_value', -1);
  static const country = StringKey('System', 'countryCode', '49');
  static const emulatedLanguage = IntKey('System', 'systemLanguage', 1);
  static const username = StringKey('System', 'username', 'AZAHAR');
  static const playCoins = IntKey('System', 'playCoins', 42);
  static const stepsPerHour = IntKey('System', 'steps_per_hour', 0);
  static const scanRealWifiNetworks = IntBoolKey('System', 'scan_real_wifi_networks', true);
  static const consoleId = StringKey('System', 'consoleId', '');
  static const mac = StringKey('System', 'mac', '');
  static const birthdayMonth = IntKey('System', 'birthdayMonth', 11);
  static const birthdayDay = IntKey('System', 'birthdayDay', 7);
  static const initClock = IntKey('System', 'init_clock', 0);
  static const initTime = StringKey('System', 'init_time', '946731601');
  static const pluginLoader = IntBoolKey('System', 'plugin_loader', false);
  static const allowPluginLoader = IntBoolKey('System', 'allow_plugin_loader', true);
}

/// The System category's items in the current Options UI: just the console clock, since New 3DS
/// mode/high-level emulation/frame limit/plugin loader now live flat under the Emulation
/// category.
List<SettingsItem> buildClockSettingsItems(Translations t) {
  final s = t.settings.system;
  return [
    SettingsItem.singleChoice(
      title: s.initClock,
      setting: SystemSettingKeys.initClock,
      choiceLabels: [s.initClockDeviceClock, s.initClockSimulatedClock],
      choiceValues: const [0, 1],
    ),
    SettingsItem.dateTime(title: s.simulatedClock, setting: SystemSettingKeys.initTime),
  ];
}

/// The pre-redesign System settings page's items. Kept only for [LegacySystemSettingsPage]
/// (`useLegacySettingsUI`); the current UI splits this content between the Emulation and System
/// categories instead.
@Deprecated('Only used by LegacySystemSettingsPage.')
List<SettingsItem> buildSystemSettingsItems(Translations t) {
  final s = t.settings.system;
  final g = t.settings.general;
  return [
    SettingsItem.switch_(
      title: g.frameLimitEnable,
      description: g.frameLimitEnableDescription,
      setting: GeneralSettingKeys.useFrameLimit,
    ),
    SettingsItem.slider(
      title: g.frameLimitSlider,
      description: g.frameLimitSliderDescription,
      setting: GeneralSettingKeys.frameLimit,
      min: 1,
      max: 200,
      units: '%',
    ),
    SettingsItem.header(title: s.clock),
    ...buildClockSettingsItems(t),
    SettingsItem.header(title: s.pluginLoader),
    SettingsItem.switch_(
      title: s.pluginLoaderEnable,
      description: s.pluginLoaderEnableDescription,
      setting: SystemSettingKeys.pluginLoader,
    ),
    SettingsItem.switch_(
      title: s.allowPluginLoader,
      description: s.allowPluginLoaderDescription,
      setting: SystemSettingKeys.allowPluginLoader,
    ),
  ];
}
