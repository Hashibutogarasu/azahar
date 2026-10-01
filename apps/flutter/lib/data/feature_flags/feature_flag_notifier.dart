import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The base of the notifier behind a feature flag. Its state is whether the flag is on, which
/// [value] exposes, and [switchTo] turns it on or off.
abstract class FeatureFlagNotifier extends Notifier<bool> {
  bool get value => state;

  Future<void> switchTo(bool value);
}
