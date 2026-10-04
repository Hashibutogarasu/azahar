import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../user/user_database.dart';
import 'animation_speed.dart';

final advancedSettingsProvider =
    NotifierProvider<AdvancedSettingsNotifier, AdvancedSetting>(
      AdvancedSettingsNotifier.new,
    );

class AdvancedSettingsNotifier extends Notifier<AdvancedSetting> {
  @override
  AdvancedSetting build() {
    _load();
    return const AdvancedSetting(id: 0, animationSpeed: AnimationSpeed.normal);
  }

  Future<void> _load() async {
    state = await AppServices.advancedSettingsRepository.read();
  }

  Future<void> setAnimationSpeed(AnimationSpeed animationSpeed) async {
    final updated = state.copyWith(animationSpeed: animationSpeed);
    state = updated;
    await AppServices.advancedSettingsRepository.write(updated);
  }
}
