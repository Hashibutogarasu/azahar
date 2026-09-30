import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/app_routes.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';

/// The Accessibility category: the page for the accessibility settings.
final accessibilityOptionsProvider = Provider<OptionCategory>(
  (ref) => const OptionCategory(
    id: 'accessibility',
    titleKey: 'options.groups.accessibility',
    sections: [
      OptionSection(
        options: [
          NestedOption(
            titleKey: 'options.accessibility',
            descriptionKey: 'options.accessibilityDescription',
            icon: Icons.accessibility_new_outlined,
            destination: OptionsAccessibilitySettingsRoute(),
          ),
        ],
      ),
    ],
  ),
);
