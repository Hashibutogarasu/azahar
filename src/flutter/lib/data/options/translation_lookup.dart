import '../../i18n/translations.g.dart';

/// Looks translations up by their key path, such as `settings.graphics.title`.
extension TranslationLookup on Translations {
  /// The translated text for [key], or null when the key does not exist or is not plain text.
  String? lookup(String key) {
    final value = this[key];
    return value is String ? value : null;
  }

  /// The translated text for [key], or the key itself when there is none.
  String resolve(String key) => lookup(key) ?? key;
}
