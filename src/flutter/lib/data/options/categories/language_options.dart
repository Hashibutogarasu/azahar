import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../i18n/translations.g.dart';
import '../../settings/options_settings_provider.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';

/// The items of the language settings page, which is not listed on the Options page: the app
/// language, with one choice per available locale plus the system default. The system default is
/// stored as null and represented by an empty string here.
final languageOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'language',
    title: (t) => t.settings.language.title,
    sections: [
      OptionSection(
        options: [
          EnumOption<String>(
            title: (t) => t.settings.language.title,
            icon: Icons.language,
            value: CallbackOptionValue<String>(
              onRead: (ref) =>
                  ref.read(optionsSettingsProvider).languageCode ?? '',
              onWrite: (context, ref, value) => ref
                  .read(optionsSettingsProvider)
                  .setLanguageCode(value.isEmpty ? null : value),
            ),
            choices: [
              EnumChoice(
                label: (t) => t.settings.language.systemDefault,
                value: '',
              ),
              for (final locale in AppLocale.values)
                EnumChoice(
                  label: (t) => switch (locale) {
                    AppLocale.en => t.settings.language.english,
                    AppLocale.ja => t.settings.language.japanese,
                  },
                  value: locale.languageCode,
                ),
            ],
          ),
        ],
      ),
    ],
  ),
);
