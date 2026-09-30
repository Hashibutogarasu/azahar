import '../../i18n/translations.g.dart';

/// Picks a translated text out of [Translations], for example `(t) => t.settings.graphics.title`.
/// Reading the text through the generated accessors keeps it checked by the compiler and
/// completable in the editor, unlike a key path written as a string.
typedef TranslationText = String Function(Translations t);
