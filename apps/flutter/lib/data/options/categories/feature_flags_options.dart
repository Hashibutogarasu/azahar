import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/feature_flags_provider.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';

/// The items of the feature flags page, which is reached from the Other category: the experimental
/// flags, each of which enables a feature that is still being evaluated.
final featureFlagsOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'featureFlags',
    title: (t) => t.settings.featureFlags.title,
    sections: [
      OptionSection(
        title: (t) => t.settings.featureFlags.experimental,
        options: [
          BoolOption(
            title: (t) => t.settings.featureFlags.performanceImprovements,
            description: (t) =>
                t.settings.featureFlags.performanceImprovementsDescription,
            icon: Icons.speed,
            value: CallbackOptionValue<bool>(
              onRead: (ref) => ref.watch(performanceImprovementsProvider),
              onWrite: (context, ref, value) => ref
                  .read(featureFlagsProvider.notifier)
                  .setPerformanceImprovements(value),
            ),
          ),
        ],
      ),
    ],
  ),
);
