import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../settings/country.dart';
import '../../settings/sections/system_settings.dart';
import '../../settings/system_save_value_store.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';
import '../store_option_values.dart';

/// The items of the profile settings page: the emulated console's profile (region, country,
/// language, user name, Play Coins, steps, Console ID, MAC address) followed by the birthday.
/// It is shown by that page and is not listed on the Options page.
final profileOptionsProvider = Provider<OptionCategory>((ref) {
  final systemSaveStore = SystemSaveValueStore(
    AppServices.systemSaveRepository,
  );
  return OptionCategory(
    id: 'profile',
    titleKey: 'settings.general.title',
    sections: [
      OptionSection(
        titleKey: 'settings.system.profileSettings',
        options: [
          const EnumOption<int>(
            titleKey: 'settings.system.emulatedRegion',
            icon: Icons.public,
            value: StoreIntValue(SystemSettingKeys.emulatedRegion),
            choices: [
              EnumChoice(
                labelKey: 'settings.system.regionAutoSelect',
                value: -1,
              ),
              EnumChoice(labelKey: 'settings.system.regionJapan', value: 0),
              EnumChoice(labelKey: 'settings.system.regionUsa', value: 1),
              EnumChoice(labelKey: 'settings.system.regionEurope', value: 2),
              EnumChoice(labelKey: 'settings.system.regionAustralia', value: 3),
              EnumChoice(labelKey: 'settings.system.regionChina', value: 4),
              EnumChoice(labelKey: 'settings.system.regionKorea', value: 5),
              EnumChoice(labelKey: 'settings.system.regionTaiwan', value: 6),
            ],
          ),
          EnumOption<Country>(
            titleKey: 'settings.system.country',
            icon: Icons.flag_outlined,
            value: CallbackOptionValue<Country>(
              onRead: (ref) =>
                  Country.fromCode(
                    int.parse(
                      systemSaveStore.readString(SystemSettingKeys.country),
                    ),
                  ) ??
                  Country.japan,
              onWrite: (context, ref, value) => systemSaveStore.writeString(
                SystemSettingKeys.country,
                value.code.toString(),
              ),
            ),
            choices: [
              for (final country in Country.values)
                EnumChoice(labelKey: country.labelKey, value: country),
            ],
          ),
          EnumOption<int>(
            titleKey: 'settings.system.emulatedLanguage',
            icon: Icons.translate,
            value: StoreIntValue(
              SystemSettingKeys.emulatedLanguage,
              store: systemSaveStore,
            ),
            choices: const [
              EnumChoice(
                labelKey: 'settings.system.languageJapanese',
                value: 0,
              ),
              EnumChoice(labelKey: 'settings.system.languageEnglish', value: 1),
              EnumChoice(labelKey: 'settings.system.languageFrench', value: 2),
              EnumChoice(labelKey: 'settings.system.languageGerman', value: 3),
              EnumChoice(labelKey: 'settings.system.languageItalian', value: 4),
              EnumChoice(labelKey: 'settings.system.languageSpanish', value: 5),
              EnumChoice(
                labelKey: 'settings.system.languageSimplifiedChinese',
                value: 6,
              ),
              EnumChoice(labelKey: 'settings.system.languageKorean', value: 7),
              EnumChoice(labelKey: 'settings.system.languageDutch', value: 8),
              EnumChoice(
                labelKey: 'settings.system.languagePortuguese',
                value: 9,
              ),
              EnumChoice(
                labelKey: 'settings.system.languageRussian',
                value: 10,
              ),
              EnumChoice(
                labelKey: 'settings.system.languageTraditionalChinese',
                value: 11,
              ),
            ],
          ),
          StringOption(
            titleKey: 'settings.system.username',
            icon: Icons.person_outline,
            value: StoreStringValue(
              SystemSettingKeys.username,
              store: systemSaveStore,
            ),
            maxLength: 10,
          ),
          IntOption(
            titleKey: 'settings.system.playCoins',
            icon: Icons.monetization_on_outlined,
            value: StoreIntValue(
              SystemSettingKeys.playCoins,
              store: systemSaveStore,
            ),
            min: 0,
            max: 300,
            defaultValue: SystemSettingKeys.playCoins.defaultValue,
          ),
          IntOption(
            titleKey: 'settings.system.stepsPerHour',
            descriptionKey: 'settings.system.stepsPerHourDescription',
            icon: Icons.directions_walk,
            value: const StoreIntValue(SystemSettingKeys.stepsPerHour),
            min: 0,
            max: 65535,
            defaultValue: SystemSettingKeys.stepsPerHour.defaultValue,
          ),
          ActionOption(
            titleKey: 'settings.system.consoleId',
            descriptionKey: 'settings.system.consoleIdDescription',
            icon: Icons.badge_outlined,
            onTap: (context, ref) => systemSaveStore.regenerateConsoleId(),
          ),
          ActionOption(
            titleKey: 'settings.system.macAddress',
            descriptionKey: 'settings.system.macAddressDescription',
            icon: Icons.router_outlined,
            onTap: (context, ref) => systemSaveStore.regenerateMac(),
          ),
        ],
      ),
      OptionSection(
        titleKey: 'settings.system.birthday',
        options: [
          EnumOption<int>(
            titleKey: 'settings.system.birthdayMonth',
            icon: Icons.cake_outlined,
            value: StoreIntValue(
              SystemSettingKeys.birthdayMonth,
              store: systemSaveStore,
            ),
            choices: const [
              EnumChoice(labelKey: 'settings.system.monthJanuary', value: 1),
              EnumChoice(labelKey: 'settings.system.monthFebruary', value: 2),
              EnumChoice(labelKey: 'settings.system.monthMarch', value: 3),
              EnumChoice(labelKey: 'settings.system.monthApril', value: 4),
              EnumChoice(labelKey: 'settings.system.monthMay', value: 5),
              EnumChoice(labelKey: 'settings.system.monthJune', value: 6),
              EnumChoice(labelKey: 'settings.system.monthJuly', value: 7),
              EnumChoice(labelKey: 'settings.system.monthAugust', value: 8),
              EnumChoice(labelKey: 'settings.system.monthSeptember', value: 9),
              EnumChoice(labelKey: 'settings.system.monthOctober', value: 10),
              EnumChoice(labelKey: 'settings.system.monthNovember', value: 11),
              EnumChoice(labelKey: 'settings.system.monthDecember', value: 12),
            ],
          ),
          IntOption(
            titleKey: 'settings.system.birthdayDay',
            icon: Icons.event,
            value: StoreIntValue(
              SystemSettingKeys.birthdayDay,
              store: systemSaveStore,
            ),
            min: 1,
            max: 31,
            defaultValue: SystemSettingKeys.birthdayDay.defaultValue,
          ),
        ],
      ),
    ],
  );
});
