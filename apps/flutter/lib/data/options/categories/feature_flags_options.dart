import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/feature_flags_provider.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';

/// The items of the feature flags page, which is reached from the Other category: one switch for
/// each flag of [featureFlagsProvider], under the experimental heading. Switching one finds its
/// flag in that list and calls its `switchTo`.
final featureFlagsOptionsProvider = Provider<OptionCategory>((ref) {
  final featureFlags = ref.watch(featureFlagsProvider);
  return OptionCategory(
    id: 'featureFlags',
    title: (t) => t.settings.featureFlags.title,
    sections: [
      OptionSection(
        title: (t) => t.settings.featureFlags.experimental,
        options: [
          for (final featureFlag in featureFlags)
            BoolOption(
              title: featureFlag.title,
              description: featureFlag.description,
              icon: featureFlag.icon ?? Icons.flag_outlined,
              value: CallbackOptionValue<bool>(
                onRead: featureFlag.read,
                onWrite: (context, ref, value) => ref
                    .read(featureFlagsProvider)
                    .firstWhere((flag) => flag.id == featureFlag.id)
                    .switchTo(ref, value),
              ),
            ),
        ],
      ),
    ],
  );
});
