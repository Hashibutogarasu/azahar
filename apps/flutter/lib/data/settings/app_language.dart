import '../../i18n/translations.g.dart';

/// Shows the UI in the language of [languageCode], or in the language of the device when it is
/// null.
Future<void> applyLanguageCode(String? languageCode) async {
  if (languageCode == null) {
    await LocaleSettings.useDeviceLocale();
  } else {
    await LocaleSettings.setLocaleRaw(languageCode);
  }
}
