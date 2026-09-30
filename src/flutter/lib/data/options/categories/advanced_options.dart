import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/advanced_settings_provider.dart';
import '../../settings/animation_speed.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';

/// The items of the advanced settings page, which is not listed on the Options page: the animation
/// speed.
final advancedOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'advanced',
    title: (t) => t.settings.advanced.title,
    sections: [
      OptionSection(
        options: [
          EnumOption<AnimationSpeed>(
            title: (t) => t.settings.advanced.animationSpeedLabel,
            description: (t) => t.settings.advanced.animationSpeedDescription,
            icon: Icons.tune,
            value: CallbackOptionValue<AnimationSpeed>(
              onRead: (ref) =>
                  ref.watch(advancedSettingsProvider).animationSpeed,
              onWrite: (context, ref, value) => ref
                  .read(advancedSettingsProvider.notifier)
                  .setAnimationSpeed(value),
            ),
            choices: [
              EnumChoice(
                label: (t) => t.settings.advanced.animationSpeed.fast,
                value: AnimationSpeed.fast,
              ),
              EnumChoice(
                label: (t) => t.settings.advanced.animationSpeed.normal,
                value: AnimationSpeed.normal,
              ),
              EnumChoice(
                label: (t) => t.settings.advanced.animationSpeed.slow,
                value: AnimationSpeed.slow,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
);
