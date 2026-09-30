import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/accessibility_settings_provider.dart';
import '../../settings/page_transition_style.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';

/// The options on the Accessibility page: reducing motion and choosing the page transition.
final accessibilityPageOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'accessibilityPage',
    titleKey: 'settings.accessibility.title',
    sections: [
      OptionSection(
        options: [
          BoolOption(
            titleKey: 'settings.accessibility.reduceMotion',
            descriptionKey: 'settings.accessibility.reduceMotionDescription',
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
            titleKey: 'settings.accessibility.pageTransition',
            descriptionKey: 'settings.accessibility.pageTransitionDescription',
            icon: Icons.animation,
            value: CallbackOptionValue<PageTransitionStyle>(
              onRead: (ref) =>
                  ref.watch(accessibilitySettingsProvider).pageTransition,
              onWrite: (context, ref, value) => ref
                  .read(accessibilitySettingsProvider.notifier)
                  .setPageTransition(value),
            ),
            choices: const [
              EnumChoice(
                labelKey: 'settings.accessibility.pageTransitionSlide',
                value: PageTransitionStyle.slide,
              ),
              EnumChoice(
                labelKey: 'settings.accessibility.pageTransitionStandard',
                value: PageTransitionStyle.standard,
              ),
              EnumChoice(
                labelKey: 'settings.accessibility.pageTransitionNone',
                value: PageTransitionStyle.none,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
);
