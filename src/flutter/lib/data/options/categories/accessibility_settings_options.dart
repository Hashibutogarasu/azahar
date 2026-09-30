import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/accessibility_settings_provider.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';

/// The items of the accessibility settings page, which is not listed on the Options page: the
/// reduce-motion switch.
final accessibilitySettingsOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'accessibilitySettings',
    title: (t) => t.settings.accessibility.title,
    sections: [
      OptionSection(
        options: [
          BoolOption(
            title: (t) => t.settings.accessibility.reduceMotion,
            description: (t) =>
                t.settings.accessibility.reduceMotionDescription,
            icon: Icons.motion_photos_off_outlined,
            value: CallbackOptionValue<bool>(
              onRead: (ref) =>
                  ref.watch(accessibilitySettingsProvider).reduceMotion,
              onWrite: (context, ref, value) => ref
                  .read(accessibilitySettingsProvider.notifier)
                  .setReduceMotion(value),
            ),
          ),
        ],
      ),
    ],
  ),
);
