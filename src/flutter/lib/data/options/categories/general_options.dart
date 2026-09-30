import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/app_routes.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';

/// The General category: the pages for the profile, language, theme and media settings.
final generalOptionsProvider = Provider<OptionCategory>(
  (ref) => const OptionCategory(
    id: 'general',
    titleKey: 'options.groups.general',
    sections: [
      OptionSection(
        options: [
          NestedOption(
            titleKey: 'options.general',
            descriptionKey: 'options.generalDescription',
            icon: Icons.account_circle_outlined,
            destination: OptionsGeneralSettingsRoute(),
          ),
          NestedOption(
            titleKey: 'settings.language.title',
            icon: Icons.language,
            destination: OptionsLanguageSettingsRoute(),
          ),
          NestedOption(
            titleKey: 'options.themeAndColor',
            descriptionKey: 'options.themeAndColorDescription',
            icon: Icons.palette_outlined,
            destination: OptionsThemeSettingsRoute(),
          ),
          NestedOption(
            titleKey: 'options.media',
            descriptionKey: 'options.mediaDescription',
            icon: Icons.music_note_outlined,
            destination: OptionsMediaSettingsRoute(),
          ),
        ],
      ),
    ],
  ),
);
