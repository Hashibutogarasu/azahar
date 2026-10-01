import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../database.dart';
import '../settings/settings_load_provider.dart';

/// The base of the notifier behind a feature flag. Its state is whether the flag is on, which
/// [value] exposes, and [switchTo] turns it on or off and keeps the choice under the flag [id].
abstract class FeatureFlagNotifier extends Notifier<bool> {
  String get id;

  bool get value => state;

  @override
  bool build() {
    ref.watch(settingsLoadProvider);
    return AppServices.featureFlagsRepository.valueOf(id);
  }

  Future<void> switchTo(bool value) async {
    state = value;
    await AppServices.featureFlagsRepository.write(
      FeatureFlagSetting(id: id, value: value),
    );
  }
}
