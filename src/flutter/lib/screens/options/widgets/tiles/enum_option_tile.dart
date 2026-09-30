import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/options/abstract_base_option.dart';
import '../../../../data/options/option_values_revision_provider.dart';
import '../../../../data/options/translation_lookup.dart';
import '../../../../i18n/translations.g.dart';
import '../../../settings/dialogs/choice_dialog.dart';
import 'option_commit.dart';

/// The tile of an [EnumOption]: shows the label of the current choice and opens a dialog listing
/// all choices to change it.
class EnumOptionTile<T> extends ConsumerWidget {
  const EnumOptionTile({
    super.key,
    required this.option,
    required this.onAccessed,
    required this.onLongPress,
  });

  final EnumOption<T> option;
  final VoidCallback onAccessed;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(optionValuesRevisionProvider);
    final t = context.t;
    final title = t.resolve(option.titleKey);
    final descriptionKey = option.descriptionKey;
    final current = option.value.read(ref);
    final currentLabel = [
      for (final choice in option.choices)
        if (choice.value == current) t.resolve(choice.labelKey),
    ].firstOrNull;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: onLongPress,
      child: babstrap.SettingsItem(
        icons: option.icon,
        title: title,
        subtitle: descriptionKey == null ? null : t.lookup(descriptionKey),
        trailing: Text(currentLabel ?? ''),
        onTap: () async {
          final result = await ChoiceDialog.show<T>(
            context,
            title: title,
            labels: [
              for (final choice in option.choices) t.resolve(choice.labelKey),
            ],
            values: [for (final choice in option.choices) choice.value],
            current: current,
          );
          if (result == null || !context.mounted) return;
          await ref.commitOptionValue(
            context,
            option.value,
            result,
            onAccessed,
          );
        },
      ),
    );
  }
}
