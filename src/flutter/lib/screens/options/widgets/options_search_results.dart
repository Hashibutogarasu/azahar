import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/options/option_entry.dart';
import '../../../data/options/options_search_provider.dart';
import '../../../data/options/translation_lookup.dart';
import '../../../i18n/translations.g.dart';
import 'option_group_card.dart';

/// The Options page's content while searching: the items matching the query, grouped by the
/// category and section they belong to, or a message when there is nothing to show.
class OptionsSearchResults extends ConsumerWidget {
  const OptionsSearchResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final query = ref.watch(optionsSearchProvider).query.trim();
    final results = ref.watch(optionsSearchResultsProvider(t));
    if (query.isEmpty || results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            query.isEmpty ? t.options.searchPrompt : t.options.searchNoResults,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final groups = <List<OptionEntry>>[];
    for (final entry in results) {
      if (groups.isNotEmpty &&
          identical(groups.last.first.section, entry.section)) {
        groups.last.add(entry);
      } else {
        groups.add([entry]);
      }
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final group in groups)
          OptionGroupCard(
            title: t.resolve(
              group.first.section.titleKey ?? group.first.category.titleKey,
            ),
            entries: group,
          ),
      ],
    );
  }
}
