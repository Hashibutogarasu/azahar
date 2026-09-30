import '../../i18n/translations.g.dart';
import 'option_entry.dart';

/// Matches Options items against a search query using only what they already have: their title
/// and description in the current locale, together with the text of the category and section they
/// belong to.
abstract final class OptionSearch {
  /// Whether [entry] contains every whitespace-separated term of [query], ignoring case.
  /// A blank query matches nothing.
  static bool matches(OptionEntry entry, String query, Translations t) {
    final terms = query
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((term) => term.isNotEmpty)
        .toList();
    if (terms.isEmpty) return false;
    final haystack = _searchableTexts(entry, t).join('\n').toLowerCase();
    return terms.every(haystack.contains);
  }

  /// The items of [entries] that match [query], in their original order.
  static List<OptionEntry> filter(
    List<OptionEntry> entries,
    String query,
    Translations t,
  ) => [
    for (final entry in entries)
      if (matches(entry, query, t)) entry,
  ];

  static List<String> _searchableTexts(OptionEntry entry, Translations t) {
    final texts = [
      entry.option.title,
      entry.option.description,
      entry.category.title,
      entry.section.title,
    ];
    return [
      for (final text in texts)
        if (text != null) text(t),
    ];
  }
}
