import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../database.dart';

final featureFlagsProvider =
    NotifierProvider<FeatureFlagsNotifier, FeatureFlag>(
      FeatureFlagsNotifier.new,
    );

/// Whether the performance improvements feature flag is on.
final performanceImprovementsProvider = Provider<bool>(
  (ref) => ref.watch(
    featureFlagsProvider.select((flags) => flags.performanceImprovements),
  ),
);

class FeatureFlagsNotifier extends Notifier<FeatureFlag> {
  @override
  FeatureFlag build() => AppServices.featureFlagsRepository.flags;

  Future<void> setPerformanceImprovements(bool performanceImprovements) async {
    final updated = state.copyWith(
      performanceImprovements: performanceImprovements,
    );
    state = updated;
    await AppServices.featureFlagsRepository.write(updated);
  }
}
