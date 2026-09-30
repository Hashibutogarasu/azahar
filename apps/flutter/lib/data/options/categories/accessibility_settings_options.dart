import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/accessibility_settings_provider.dart';
import '../../settings/page_transition_style.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';

/// The items of the accessibility settings page, which is not listed on the Options page: the
/// reduce-motion switch and the page transition.
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
          EnumOption<PageTransitionStyle>(
            title: (t) => t.settings.accessibility.pageTransition,
            description: (t) =>
                t.settings.accessibility.pageTransitionDescription,
            icon: Icons.animation,
            value: CallbackOptionValue<PageTransitionStyle>(
              onRead: (ref) =>
                  ref.watch(accessibilitySettingsProvider).pageTransition,
              onWrite: (context, ref, value) => ref
                  .read(accessibilitySettingsProvider.notifier)
                  .setPageTransition(value),
            ),
            choices: [
              EnumChoice(
                label: (t) => t.settings.accessibility.pageTransitionSlide,
                value: PageTransitionStyle.slide,
              ),
              EnumChoice(
                label: (t) => t.settings.accessibility.pageTransitionStandard,
                value: PageTransitionStyle.standard,
              ),
              EnumChoice(
                label: (t) => t.settings.accessibility.pageTransitionNone,
                value: PageTransitionStyle.none,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
);
