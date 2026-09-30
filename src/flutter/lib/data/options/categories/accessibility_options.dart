import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/app_routes.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';

/// The Accessibility category: the page for the accessibility settings.
final accessibilityOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'accessibility',
    title: (t) => t.options.groups.accessibility,
    sections: [
      OptionSection(
        options: [
          NestedOption(
            title: (t) => t.options.accessibility,
            description: (t) => t.options.accessibilityDescription,
            icon: Icons.accessibility_new_outlined,
            destination: const OptionsAccessibilitySettingsRoute(),
          ),
        ],
      ),
    ],
  ),
);
