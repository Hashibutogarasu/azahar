import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/options/abstract_base_option.dart';
import '../../../../data/options/option_values_revision_provider.dart';
import '../../../../data/options/translation_lookup.dart';
import '../../../../i18n/translations.g.dart';
import '../../../settings/dialogs/date_time_picker.dart';
import 'option_commit.dart';

/// The tile of a [DateTimeOption]: shows the stored time and opens a date and a time picker to
/// change it.
class DateTimeOptionTile extends ConsumerWidget {
  const DateTimeOptionTile({
    super.key,
    required this.option,
    required this.onAccessed,
    required this.onLongPress,
  });

  final DateTimeOption option;
  final VoidCallback onAccessed;
  final VoidCallback onLongPress;

  DateTime? _parse(String raw) {
    final seconds = int.tryParse(raw);
    if (seconds == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000,
      isUtc: true,
    ).toLocal();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(optionValuesRevisionProvider);
    final t = context.t;
    final descriptionKey = option.descriptionKey;
    final raw = option.value.read(ref);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: onLongPress,
      child: babstrap.SettingsItem(
        icons: option.icon,
        title: t.resolve(option.titleKey),
        subtitle: descriptionKey == null ? null : t.lookup(descriptionKey),
        trailing: Text(_parse(raw)?.toString() ?? raw),
        onTap: () async {
          final result = await DateTimePicker.show(
            context,
            initial: _parse(raw) ?? DateTime.now(),
          );
          if (result == null || !context.mounted) return;
          await ref.commitOptionValue(
            context,
            option.value,
            (result.toUtc().millisecondsSinceEpoch ~/ 1000).toString(),
            onAccessed,
          );
        },
      ),
    );
  }
}
