import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../i18n/translations.g.dart';
import 'option_categories_provider.dart';
import 'option_entry.dart';
import 'option_search.dart';

/// Whether the Options page is in search mode, and what is being searched for.
class OptionsSearchState {
  const OptionsSearchState({this.isActive = false, this.query = ''});

  final bool isActive;
  final String query;
}

final optionsSearchProvider =
    NotifierProvider<OptionsSearchNotifier, OptionsSearchState>(
      OptionsSearchNotifier.new,
    );

class OptionsSearchNotifier extends Notifier<OptionsSearchState> {
  @override
  OptionsSearchState build() => const OptionsSearchState();

  /// Switches the page to the search results, keeping the current query.
  void activate() =>
      state = OptionsSearchState(isActive: true, query: state.query);

  void setQuery(String query) =>
      state = OptionsSearchState(isActive: true, query: query);

  /// Leaves search mode and forgets the query.
  void deactivate() => state = const OptionsSearchState();
}

/// The items matching the current query, searched in the language of [t].
final optionsSearchResultsProvider =
    Provider.family<List<OptionEntry>, Translations>((ref, t) {
      final query = ref.watch(optionsSearchProvider).query;
      return OptionSearch.filter(ref.watch(optionEntriesProvider), query, t);
    });
