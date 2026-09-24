import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';

final settingsLoadProvider = NotifierProvider<SettingsLoadNotifier, bool>(
  SettingsLoadNotifier.new,
);

class SettingsLoadNotifier extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return false;
  }

  Future<void> _load() async {
    await AppServices.emulatorSettingsRepository.load();
    await AppServices.systemSaveRepository.load();
    await AppServices.controlBindingsValueStore.load();
    await AppServices.settingsRepository.loadLanguageCode();
    await AppServices.settingsRepository.loadUseLegacySettingsUI();
    state = true;
  }
}
