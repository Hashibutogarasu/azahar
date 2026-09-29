import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../repositories/clearable.dart';

final resetSettingsProvider = Provider<ResetSettingsService>(
  (ref) => ResetSettingsService(),
);

class ResetSettingsService {
  static final List<Clearable> _clearables = [
    AppServices.emulatorSettingsRepository,
    AppServices.systemSaveRepository,
    AppServices.controlBindingsRepository,
  ];

  Future<void> resetAll() async {
    for (final clearable in _clearables) {
      await clearable.clear();
    }
  }
}
