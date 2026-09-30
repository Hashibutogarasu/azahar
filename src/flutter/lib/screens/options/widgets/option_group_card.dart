import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/options/option_entry.dart';
import '../../../data/options/option_history_provider.dart';
import '../../settings/widgets/settings_group_card.dart';
import 'option_actions_sheet.dart';
import 'widget_settings_item.dart';

/// A titled card of Options items. It only asks each item for its widget through `toWidget`, so
/// the categories, the history, the pinned items and the search results all behave the same:
/// using an item records it in the history, and pressing and holding it opens
/// [OptionActionsSheet].
///
/// While [entries] is empty and an [emptyMessage] is given, the message is shown in place of the
/// items. [trailing] is placed at the right end of the title row. Set [inHistory] for the History
/// section, whose items can also be removed from the history from their long-press menu.
class OptionGroupCard extends ConsumerWidget {
  const OptionGroupCard({
    super.key,
    this.title,
    required this.entries,
    this.emptyMessage,
    this.trailing,
    this.inHistory = false,
  });

  final String? title;
  final List<OptionEntry> entries;
  final String? emptyMessage;
  final Widget? trailing;
  final bool inHistory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsGroupCard(
      settingsGroupTitle: title,
      trailing: trailing,
      items: [
        if (entries.isEmpty && emptyMessage != null)
          WidgetSettingsItem(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                emptyMessage!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        for (final entry in entries)
          WidgetSettingsItem(
            child: entry.option.toWidget(
              onAccessed: () =>
                  ref.read(optionHistoryProvider.notifier).record(entry.id),
              onLongPress: () => OptionActionsSheet.show(
                context,
                entry,
                removableFromHistory: inHistory,
              ),
            ),
          ),
      ],
    );
  }
}
