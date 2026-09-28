import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../database.dart';

final debugSettingsProvider =
    AsyncNotifierProvider<DebugSettingsNotifier, DebugSetting>(
      DebugSettingsNotifier.new,
    );

class DebugSettingsNotifier extends AsyncNotifier<DebugSetting> {
  @override
  Future<DebugSetting> build() {
    return AppServices.debugSettingsRepository.read();
  }

  Future<void> setLogToConsole(bool enabled) async {
    final current = await future;
    final updated = current.copyWith(logToConsole: enabled);
    await AppServices.debugSettingsRepository.write(updated);
    state = AsyncData(updated);
    await applyDebugSettings(updated);
  }
}

Future<void> applyDebugSettings(DebugSetting settings) async {
  await AppServices.nativeBridge.setConsoleLogEnabled(settings.logToConsole);
}
