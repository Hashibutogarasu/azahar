import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/options/option_categories_provider.dart';
import '../../../data/options/option_history_provider.dart';
import '../../../data/options/pinned_options_provider.dart';
import '../../../i18n/translations.g.dart';
import 'clear_section_button.dart';
import 'emulator_load_section.dart';
import 'option_category_cards.dart';
import 'option_group_card.dart';

/// What the Options page shows when it is not searching: the recently used items, the pinned
/// items, and then every category. The first two are always shown, with a message while empty and
/// a button at the right of their heading that deletes everything in them after confirmation.
class OptionsHomeContent extends ConsumerWidget {
  const OptionsHomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final index = ref.watch(optionEntryByIdProvider);
    final historyEntries = [
      for (final id in ref.watch(optionHistoryProvider).value ?? const [])
        ?index[id],
    ];
    final pinnedEntries = [
      for (final id in ref.watch(pinnedOptionsProvider).value ?? const [])
        ?index[id],
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const EmulatorLoadSection(),
        OptionGroupCard(
          title: t.options.history,
          entries: historyEntries,
          emptyMessage: t.options.historyEmpty,
          inHistory: true,
          trailing: ClearSectionButton(
            enabled: historyEntries.isNotEmpty,
            confirmTitle: t.options.clearHistoryTitle,
            confirmMessage: t.options.clearHistoryMessage,
            onConfirmed: () => ref.read(optionHistoryProvider.notifier).clear(),
          ),
        ),
        OptionGroupCard(
          title: t.options.pinned,
          entries: pinnedEntries,
          emptyMessage: t.options.pinnedEmpty,
          trailing: ClearSectionButton(
            enabled: pinnedEntries.isNotEmpty,
            confirmTitle: t.options.clearPinnedTitle,
            confirmMessage: t.options.clearPinnedMessage,
            onConfirmed: () => ref.read(pinnedOptionsProvider.notifier).clear(),
          ),
        ),
        for (final category in ref.watch(optionCategoriesProvider))
          OptionCategoryCards(
            category: category,
            fallbackToCategoryTitle: true,
          ),
      ],
    );
  }
}
