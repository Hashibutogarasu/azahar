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
    titleKey: 'settings.advanced.title',
    sections: [
      OptionSection(
        options: [
          EnumOption<String>(
            titleKey: 'settings.advanced.animationSpeedLabel',
            descriptionKey: 'settings.advanced.animationSpeedDescription',
            icon: Icons.tune,
            value: CallbackOptionValue<String>(
              onRead: (ref) =>
                  ref.watch(advancedSettingsProvider).animationSpeed.name,
              onWrite: (context, ref, value) => ref
                  .read(advancedSettingsProvider.notifier)
                  .setAnimationSpeed(AnimationSpeed.values.byName(value)),
            ),
            choices: [
              for (final speed in AnimationSpeed.values)
                EnumChoice(
                  labelKey: 'settings.advanced.animationSpeed.${speed.name}',
                  value: speed.name,
                ),
            ],
          ),
        ],
      ),
    ],
  ),
);
