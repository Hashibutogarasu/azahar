import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/app_routes.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';

/// The General category: the pages for the profile, language, theme and media settings.
final generalOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'general',
    title: (t) => t.options.groups.general,
    sections: [
      OptionSection(
        options: [
          NestedOption(
            title: (t) => t.options.general,
            description: (t) => t.options.generalDescription,
            icon: Icons.account_circle_outlined,
            destination: const OptionsGeneralSettingsRoute(),
          ),
          NestedOption(
            title: (t) => t.settings.language.title,
            icon: Icons.language,
            destination: const OptionsLanguageSettingsRoute(),
          ),
          NestedOption(
            title: (t) => t.options.themeAndColor,
            description: (t) => t.options.themeAndColorDescription,
            icon: Icons.palette_outlined,
            destination: const OptionsThemeSettingsRoute(),
          ),
          NestedOption(
            title: (t) => t.options.media,
            description: (t) => t.options.mediaDescription,
            icon: Icons.music_note_outlined,
            destination: const OptionsMediaSettingsRoute(),
          ),
        ],
      ),
    ],
  ),
);
