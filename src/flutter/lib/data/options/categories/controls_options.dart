import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/app_routes.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';

/// The Controls category: the page for the gamepad settings.
final controlsOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'controls',
    title: (t) => t.options.groups.controls,
    sections: [
      OptionSection(
        options: [
          NestedOption(
            title: (t) => t.settings.gamepad.title,
            icon: Icons.sports_esports,
            destination: const OptionsControlsSettingsRoute(),
          ),
        ],
      ),
    ],
  ),
);
