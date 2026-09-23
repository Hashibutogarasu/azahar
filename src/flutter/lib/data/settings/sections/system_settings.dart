import 'package:flutter/widgets.dart';

import '../../../i18n/translations.g.dart';
import '../emulator_setting_key.dart';
import '../settings_item.dart';
import '../system_save_repository.dart';
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

List<SettingsItem> buildSystemSettingsItems(
  Translations t,
  SystemSaveValueStore systemSaveStore,
  VoidCallback onChanged,
) {
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
    SettingsItem.header(title: s.profileSettings),
    SettingsItem.singleChoice(
      title: s.emulatedRegion,
      setting: SystemSettingKeys.emulatedRegion,
      choiceLabels: [
        s.regionAutoSelect,
        s.regionJapan,
        s.regionUsa,
        s.regionEurope,
        s.regionAustralia,
        s.regionChina,
        s.regionKorea,
        s.regionTaiwan,
      ],
      choiceValues: const [-1, 0, 1, 2, 3, 4, 5, 6],
    ),
    SettingsItem.stringSingleChoice(
      title: s.country,
      setting: SystemSettingKeys.country,
      choiceLabels: _countryLabels(s),
      choiceValues: _countryValues,
      store: systemSaveStore,
    ),
    SettingsItem.singleChoice(
      title: s.emulatedLanguage,
      setting: SystemSettingKeys.emulatedLanguage,
      choiceLabels: [
        s.languageJapanese,
        s.languageEnglish,
        s.languageFrench,
        s.languageGerman,
        s.languageItalian,
        s.languageSpanish,
        s.languageSimplifiedChinese,
        s.languageKorean,
        s.languageDutch,
        s.languagePortuguese,
        s.languageRussian,
        s.languageTraditionalChinese,
      ],
      choiceValues: const [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
      store: systemSaveStore,
    ),
    SettingsItem.stringInput(
      title: s.username,
      setting: SystemSettingKeys.username,
      maxLength: 10,
      store: systemSaveStore,
    ),
    SettingsItem.slider(
      title: s.playCoins,
      setting: SystemSettingKeys.playCoins,
      min: 0,
      max: 300,
      units: '',
      store: systemSaveStore,
    ),
    SettingsItem.slider(
      title: s.stepsPerHour,
      description: s.stepsPerHourDescription,
      setting: SystemSettingKeys.stepsPerHour,
      min: 0,
      max: 65535,
      units: '',
    ),
    SettingsItem.switch_(
      title: s.scanRealWifiNetworks,
      description: s.scanRealWifiNetworksDescription,
      setting: SystemSettingKeys.scanRealWifiNetworks,
    ),
    SettingsItem.action(
      title: s.consoleId,
      description: s.consoleIdDescription,
      onTap: (context) async {
        await systemSaveStore.regenerateConsoleId();
        onChanged();
      },
    ),
    SettingsItem.action(
      title: s.macAddress,
      description: s.macAddressDescription,
      onTap: (context) async {
        await systemSaveStore.regenerateMac();
        onChanged();
      },
    ),
    SettingsItem.header(title: s.birthday),
    SettingsItem.singleChoice(
      title: s.birthdayMonth,
      setting: SystemSettingKeys.birthdayMonth,
      choiceLabels: [
        s.monthJanuary,
        s.monthFebruary,
        s.monthMarch,
        s.monthApril,
        s.monthMay,
        s.monthJune,
        s.monthJuly,
        s.monthAugust,
        s.monthSeptember,
        s.monthOctober,
        s.monthNovember,
        s.monthDecember,
      ],
      choiceValues: const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
      store: systemSaveStore,
    ),
    SettingsItem.slider(
      title: s.birthdayDay,
      setting: SystemSettingKeys.birthdayDay,
      min: 1,
      max: 31,
      units: '',
      store: systemSaveStore,
    ),
  ];
}

List<String> get _countryValues =>
    SystemSaveRepository.countryCodes.map((code) => code.toString()).toList();

List<String> _countryLabels(Translations$settings$system$en s) => [
  s.countryJapan,
  s.countryAnguilla,
  s.countryAntiguaAndBarbuda,
  s.countryArgentina,
  s.countryAruba,
  s.countryBahamas,
  s.countryBarbados,
  s.countryBelize,
  s.countryBolivia,
  s.countryBrazil,
  s.countryBritishVirginIslands,
  s.countryCanada,
  s.countryCaymanIslands,
  s.countryChile,
  s.countryColombia,
  s.countryCostaRica,
  s.countryDominica,
  s.countryDominicanRepublic,
  s.countryEcuador,
  s.countryElSalvador,
  s.countryFrenchGuiana,
  s.countryGrenada,
  s.countryGuadeloupe,
  s.countryGuatemala,
  s.countryGuyana,
  s.countryHaiti,
  s.countryHonduras,
  s.countryJamaica,
  s.countryMartinique,
  s.countryMexico,
  s.countryMontserrat,
  s.countryNetherlandsAntilles,
  s.countryNicaragua,
  s.countryPanama,
  s.countryParaguay,
  s.countryPeru,
  s.countrySaintKittsAndNevis,
  s.countrySaintLucia,
  s.countrySaintVincentAndTheGrenadines,
  s.countrySuriname,
  s.countryTrinidadAndTobago,
  s.countryTurksAndCaicosIslands,
  s.countryUnitedStates,
  s.countryUruguay,
  s.countryUsVirginIslands,
  s.countryVenezuela,
  s.countryAlbania,
  s.countryAustralia,
  s.countryAustria,
  s.countryBelgium,
  s.countryBosniaAndHerzegovina,
  s.countryBotswana,
  s.countryBulgaria,
  s.countryCroatia,
  s.countryCyprus,
  s.countryCzechRepublic,
  s.countryDenmark,
  s.countryEstonia,
  s.countryFinland,
  s.countryFrance,
  s.countryGermany,
  s.countryGreece,
  s.countryHungary,
  s.countryIceland,
  s.countryIreland,
  s.countryItaly,
  s.countryLatvia,
  s.countryLesotho,
  s.countryLiechtenstein,
  s.countryLithuania,
  s.countryLuxembourg,
  s.countryMacedonia,
  s.countryMalta,
  s.countryMontenegro,
  s.countryMozambique,
  s.countryNamibia,
  s.countryNetherlands,
  s.countryNewZealand,
  s.countryNorway,
  s.countryPoland,
  s.countryPortugal,
  s.countryRomania,
  s.countryRussia,
  s.countrySerbia,
  s.countrySlovakia,
  s.countrySlovenia,
  s.countrySouthAfrica,
  s.countrySpain,
  s.countrySwaziland,
  s.countrySweden,
  s.countrySwitzerland,
  s.countryTurkey,
  s.countryUnitedKingdom,
  s.countryZambia,
  s.countryZimbabwe,
  s.countryAzerbaijan,
  s.countryMauritania,
  s.countryMali,
  s.countryNiger,
  s.countryChad,
  s.countrySudan,
  s.countryEritrea,
  s.countryDjibouti,
  s.countrySomalia,
  s.countryAndorra,
  s.countryGibraltar,
  s.countryGuernsey,
  s.countryIsleOfMan,
  s.countryJersey,
  s.countryMonaco,
  s.countryTaiwan,
  s.countrySouthKorea,
  s.countryHongKong,
  s.countryMacau,
  s.countryIndonesia,
  s.countrySingapore,
  s.countryThailand,
  s.countryPhilippines,
  s.countryMalaysia,
  s.countryChina,
  s.countryUnitedArabEmirates,
  s.countryIndia,
  s.countryEgypt,
  s.countryOman,
  s.countryQatar,
  s.countryKuwait,
  s.countrySaudiArabia,
  s.countrySyria,
  s.countryBahrain,
  s.countryJordan,
  s.countrySanMarino,
  s.countryVaticanCity,
  s.countryBermuda,
];
