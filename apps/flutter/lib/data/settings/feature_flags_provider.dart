import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../feature_flags/feature_flag.dart';
import '../feature_flags/feature_flag_notifier.dart';
import '../feature_flags/provider_feature_flag.dart';

/// Whether the performance improvements feature flag is on.
final performanceImprovementsProvider =
    NotifierProvider<PerformanceImprovementsNotifier, bool>(
      PerformanceImprovementsNotifier.new,
    );

class PerformanceImprovementsNotifier extends FeatureFlagNotifier {
  @override
  bool build() =>
      AppServices.featureFlagsRepository.flags.performanceImprovements;

  @override
  Future<void> switchTo(bool value) async {
    state = value;
    await AppServices.featureFlagsRepository.write(
      AppServices.featureFlagsRepository.flags.copyWith(
        performanceImprovements: value,
      ),
    );
  }
}

/// Every feature flag, in the order the feature flags page lists them. Add a flag here to list it.
final featureFlagsProvider = Provider<List<FeatureFlag>>(
  (ref) => [
    ProviderFeatureFlag(
      id: 'performanceImprovements',
      title: (t) => t.settings.featureFlags.performanceImprovements,
      description: (t) =>
          t.settings.featureFlags.performanceImprovementsDescription,
      icon: Icons.speed,
      provider: performanceImprovementsProvider,
    ),
  ],
);
