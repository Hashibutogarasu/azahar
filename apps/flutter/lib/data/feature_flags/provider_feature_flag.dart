import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'feature_flag.dart';
import 'feature_flag_notifier.dart';

/// A [FeatureFlag] whose state lives in a [FeatureFlagNotifier], so any flag is defined by its
/// texts and the provider of its notifier.
class ProviderFeatureFlag extends FeatureFlag {
  const ProviderFeatureFlag({
    required super.id,
    required super.title,
    super.description,
    super.icon,
    required this.provider,
  });

  final NotifierProvider<FeatureFlagNotifier, bool> provider;

  @override
  bool read(WidgetRef ref) => ref.watch(provider);

  @override
  Future<void> switchTo(WidgetRef ref, bool value) =>
      ref.read(provider.notifier).switchTo(value);
}
