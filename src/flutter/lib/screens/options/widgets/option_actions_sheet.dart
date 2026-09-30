import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/options/option_entry.dart';
import '../../../data/options/option_history_provider.dart';
import '../../../data/options/pinned_options_provider.dart';
import '../../../data/repositories/pinned_options_repository.dart';
import '../../../i18n/translations.g.dart';
import '../../../widgets/long_press_menu_sheet.dart';

/// The bottom sheet opened by pressing and holding an Options item, inside the same
/// [LongPressMenuSheet] frame as the game card's menu. It offers to pin the item, or to unpin it
/// when it is pinned already; while the pin limit is reached, pinning is disabled. For an item
/// shown in the History section it ends with an entry that removes just that item from the
/// history.
class OptionActionsSheet extends ConsumerWidget {
  const OptionActionsSheet({
    super.key,
    required this.entry,
    this.removableFromHistory = false,
  });

  final OptionEntry entry;
  final bool removableFromHistory;

  static Future<void> show(
    BuildContext context,
    OptionEntry entry, {
    bool removableFromHistory = false,
  }) {
    return LongPressMenuSheet.show(
      context,
      builder: (_) => OptionActionsSheet(
        entry: entry,
        removableFromHistory: removableFromHistory,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final pinned = ref.watch(pinnedOptionsProvider).value ?? const [];
    final isPinned = pinned.contains(entry.id);
    final limitReached =
        !isPinned && pinned.length >= PinnedOptionsRepository.maxPinned;
    return LongPressMenuSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FilledButton.tonal(
                onPressed: limitReached
                    ? null
                    : () async {
                        final notifier = ref.read(
                          pinnedOptionsProvider.notifier,
                        );
                        if (isPinned) {
                          await notifier.unpin(entry.id);
                        } else {
                          await notifier.pin(entry.id);
                        }
                        if (context.mounted) Navigator.of(context).pop();
                      },
                child: Text(isPinned ? t.options.unpin : t.options.pin),
              ),
            ],
          ),
          if (limitReached) ...[
            const SizedBox(height: 16),
            Text(
              t.options.pinLimitReached(
                count: PinnedOptionsRepository.maxPinned,
              ),
            ),
          ],
          if (removableFromHistory) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                FilledButton.tonal(
                  onPressed: () async {
                    await ref
                        .read(optionHistoryProvider.notifier)
                        .remove(entry.id);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: Text(t.options.removeFromHistory),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
