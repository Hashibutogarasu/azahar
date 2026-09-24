import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../data/database.dart';
import '../../i18n/translations.g.dart';
import '../../theme/theme_settings_provider.dart';
import 'reset_settings_provider.dart';

final optionsSettingsProvider = Provider<OptionsSettingsService>(
  (ref) => OptionsSettingsService(ref),
);

/// The single entry point the redesigned Options UI uses to read and write settings.
///
/// Internally this delegates to the existing repositories
/// ([AppServices.settingsRepository], [AppServices.emulatorSettingsRepository],
/// [AppServices.themeSettingsRepository], ...) so their storage isn't rewritten, but every
/// Options-side widget goes through this service instead of reaching into those repositories
/// directly.
class OptionsSettingsService {
  OptionsSettingsService(this._ref);

  final Ref _ref;

  bool get useLegacySettingsUI => AppServices.settingsRepository.useLegacySettingsUI;

  Future<void> setUseLegacySettingsUI(bool value) {
    return AppServices.settingsRepository.setUseLegacySettingsUI(value);
  }

  String? get languageCode => AppServices.settingsRepository.languageCode;

  Future<void> setLanguageCode(String? languageCode) async {
    await AppServices.settingsRepository.setLanguageCode(languageCode);
    if (languageCode == null) {
      await LocaleSettings.useDeviceLocale();
    } else {
      await LocaleSettings.setLocaleRaw(languageCode);
    }
  }

  ThemeSetting get themeSettings => _ref.read(themeSettingsProvider);

  ThemeSettingsNotifier get themeSettingsNotifier => _ref.read(themeSettingsProvider.notifier);

  Future<void> resetAll() {
    return _ref.read(resetSettingsProvider).resetAll();
  }
}
