import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../../screens/options/widgets/profile_radio_list.dart';
import '../../settings/country.dart';
import '../../settings/sections/system_settings.dart';
import '../../settings/system_save_value_store.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';
import '../store_option_values.dart';

/// The items of the profile settings page: switching between the profiles, the emulated console's
/// profile (region, country,
/// language, user name, Play Coins, steps, Console ID, MAC address) followed by the birthday.
/// It is shown by that page and is not listed on the Options page.
final profileOptionsProvider = Provider<OptionCategory>((ref) {
  final systemSaveStore = SystemSaveValueStore(
    AppServices.systemSaveRepository,
  );
  return OptionCategory(
    id: 'profile',
    title: (t) => t.settings.general.title,
    sections: [
      OptionSection(
        title: (t) => t.profiles.switchTitle,
        options: [
          CustomWidgetOption(
            title: (t) => t.profiles.switchTitle,
            icon: Icons.switch_account,
            builder: (context) => const ProfileRadioList(),
          ),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.system.profileSettings,
        options: [
          EnumOption<int>(
            title: (t) => t.settings.system.emulatedRegion,
            icon: Icons.public,
            value: const StoreIntValue(SystemSettingKeys.emulatedRegion),
            choices: [
              EnumChoice(
                label: (t) => t.settings.system.regionAutoSelect,
                value: -1,
              ),
              EnumChoice(label: (t) => t.settings.system.regionJapan, value: 0),
              EnumChoice(label: (t) => t.settings.system.regionUsa, value: 1),
              EnumChoice(
                label: (t) => t.settings.system.regionEurope,
                value: 2,
              ),
              EnumChoice(
                label: (t) => t.settings.system.regionAustralia,
                value: 3,
              ),
              EnumChoice(label: (t) => t.settings.system.regionChina, value: 4),
              EnumChoice(label: (t) => t.settings.system.regionKorea, value: 5),
              EnumChoice(
                label: (t) => t.settings.system.regionTaiwan,
                value: 6,
              ),
            ],
          ),
          EnumOption<Country>(
            title: (t) => t.settings.system.country,
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
                EnumChoice(label: country.label, value: country),
            ],
          ),
          EnumOption<int>(
            title: (t) => t.settings.system.emulatedLanguage,
            icon: Icons.translate,
            value: StoreIntValue(
              SystemSettingKeys.emulatedLanguage,
              store: systemSaveStore,
            ),
            choices: [
              EnumChoice(
                label: (t) => t.settings.system.languageJapanese,
                value: 0,
              ),
              EnumChoice(
                label: (t) => t.settings.system.languageEnglish,
                value: 1,
              ),
              EnumChoice(
                label: (t) => t.settings.system.languageFrench,
                value: 2,
              ),
              EnumChoice(
                label: (t) => t.settings.system.languageGerman,
                value: 3,
              ),
              EnumChoice(
                label: (t) => t.settings.system.languageItalian,
                value: 4,
              ),
              EnumChoice(
                label: (t) => t.settings.system.languageSpanish,
                value: 5,
              ),
              EnumChoice(
                label: (t) => t.settings.system.languageSimplifiedChinese,
                value: 6,
              ),
              EnumChoice(
                label: (t) => t.settings.system.languageKorean,
                value: 7,
              ),
              EnumChoice(
                label: (t) => t.settings.system.languageDutch,
                value: 8,
              ),
              EnumChoice(
                label: (t) => t.settings.system.languagePortuguese,
                value: 9,
              ),
              EnumChoice(
                label: (t) => t.settings.system.languageRussian,
                value: 10,
              ),
              EnumChoice(
                label: (t) => t.settings.system.languageTraditionalChinese,
                value: 11,
              ),
            ],
          ),
          StringOption(
            title: (t) => t.settings.system.username,
            icon: Icons.person_outline,
            value: StoreStringValue(
              SystemSettingKeys.username,
              store: systemSaveStore,
            ),
            maxLength: 10,
          ),
          IntOption(
            title: (t) => t.settings.system.playCoins,
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
            title: (t) => t.settings.system.stepsPerHour,
            description: (t) => t.settings.system.stepsPerHourDescription,
            icon: Icons.directions_walk,
            value: const StoreIntValue(SystemSettingKeys.stepsPerHour),
            min: 0,
            max: 65535,
            defaultValue: SystemSettingKeys.stepsPerHour.defaultValue,
          ),
          ActionOption(
            title: (t) => t.settings.system.consoleId,
            description: (t) => t.settings.system.consoleIdDescription,
            icon: Icons.badge_outlined,
            onTap: (context, ref) => systemSaveStore.regenerateConsoleId(),
          ),
          ActionOption(
            title: (t) => t.settings.system.macAddress,
            description: (t) => t.settings.system.macAddressDescription,
            icon: Icons.router_outlined,
            onTap: (context, ref) => systemSaveStore.regenerateMac(),
          ),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.system.birthday,
        options: [
          EnumOption<int>(
            title: (t) => t.settings.system.birthdayMonth,
            icon: Icons.cake_outlined,
            value: StoreIntValue(
              SystemSettingKeys.birthdayMonth,
              store: systemSaveStore,
            ),
            choices: [
              EnumChoice(
                label: (t) => t.settings.system.monthJanuary,
                value: 1,
              ),
              EnumChoice(
                label: (t) => t.settings.system.monthFebruary,
                value: 2,
              ),
              EnumChoice(label: (t) => t.settings.system.monthMarch, value: 3),
              EnumChoice(label: (t) => t.settings.system.monthApril, value: 4),
              EnumChoice(label: (t) => t.settings.system.monthMay, value: 5),
              EnumChoice(label: (t) => t.settings.system.monthJune, value: 6),
              EnumChoice(label: (t) => t.settings.system.monthJuly, value: 7),
              EnumChoice(label: (t) => t.settings.system.monthAugust, value: 8),
              EnumChoice(
                label: (t) => t.settings.system.monthSeptember,
                value: 9,
              ),
              EnumChoice(
                label: (t) => t.settings.system.monthOctober,
                value: 10,
              ),
              EnumChoice(
                label: (t) => t.settings.system.monthNovember,
                value: 11,
              ),
              EnumChoice(
                label: (t) => t.settings.system.monthDecember,
                value: 12,
              ),
            ],
          ),
          IntOption(
            title: (t) => t.settings.system.birthdayDay,
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
