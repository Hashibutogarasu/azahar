import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../database.dart';
import 'page_transition_style.dart';

final accessibilitySettingsProvider =
    NotifierProvider<AccessibilitySettingsNotifier, AccessibilitySetting>(
      AccessibilitySettingsNotifier.new,
    );

class AccessibilitySettingsNotifier extends Notifier<AccessibilitySetting> {
  @override
  AccessibilitySetting build() {
    _load();
    return const AccessibilitySetting(
      id: 0,
      reduceMotion: false,
      pageTransition: PageTransitionStyle.slide,
    );
  }

  Future<void> _load() async {
    state = await AppServices.accessibilitySettingsRepository.read();
  }

  Future<void> setReduceMotion(bool reduceMotion) async {
    final updated = state.copyWith(reduceMotion: reduceMotion);
    state = updated;
    await AppServices.accessibilitySettingsRepository.write(updated);
  }

  Future<void> setPageTransition(PageTransitionStyle pageTransition) async {
    final updated = state.copyWith(pageTransition: pageTransition);
    state = updated;
    await AppServices.accessibilitySettingsRepository.write(updated);
  }
}
