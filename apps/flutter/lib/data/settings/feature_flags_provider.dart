import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../feature_flags/feature_flag.dart';
import '../feature_flags/feature_flag_notifier.dart';
import '../feature_flags/provider_feature_flag.dart';

const performanceImprovementsFlagId = 'performanceImprovements';

/// Whether the performance improvements feature flag is on.
final performanceImprovementsProvider =
    NotifierProvider<PerformanceImprovementsNotifier, bool>(
      PerformanceImprovementsNotifier.new,
    );

class PerformanceImprovementsNotifier extends FeatureFlagNotifier {
  @override
  String get id => performanceImprovementsFlagId;
}

/// Every feature flag, in the order the feature flags page lists them. Add a flag here to list it.
final featureFlagsProvider = Provider<List<FeatureFlag>>(
  (ref) => [
    ProviderFeatureFlag(
      id: performanceImprovementsFlagId,
      title: (t) => t.settings.featureFlags.performanceImprovements,
      description: (t) =>
          t.settings.featureFlags.performanceImprovementsDescription,
      icon: Icons.speed,
      provider: performanceImprovementsProvider,
    ),
  ],
);
