import '../../../i18n/translations.g.dart';
import '../emulator_setting_key.dart';
import '../settings_item.dart';
import '../system_save_value_store.dart';

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

List<SettingsItem> buildSystemSettingsItems(Translations t, SystemSaveValueStore systemSaveStore) {
  final s = t.settings.system;
  return [
    SettingsItem.header(title: s.emulationSettings),
    SettingsItem.switch_(
      title: s.new3ds,
      description: s.new3dsDescription,
      setting: SystemSettingKeys.new3ds,
    ),
    SettingsItem.switch_(
      title: s.lleApplets,
      description: s.lleAppletsDescription,
      setting: SystemSettingKeys.lleApplets,
    ),
    SettingsItem.switch_(
      title: s.requiredOnlineLleModules,
      description: s.requiredOnlineLleModulesDescription,
      setting: SystemSettingKeys.requiredOnlineLleModules,
    ),
  ];
}
