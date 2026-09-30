import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/options/abstract_base_option.dart';
import '../../../../data/options/option_values_revision_provider.dart';
import '../../../../i18n/translations.g.dart';
import '../../../settings/dialogs/text_input_dialog.dart';
import 'option_commit.dart';

/// The tile of a [StringOption]: shows the text and opens a text dialog to change it.
class StringOptionTile extends ConsumerWidget {
  const StringOptionTile({
    super.key,
    required this.option,
    required this.onAccessed,
    required this.onLongPress,
  });

  final StringOption option;
  final VoidCallback onAccessed;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(optionValuesRevisionProvider);
    final t = context.t;
    final title = option.title(t);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: onLongPress,
      child: babstrap.SettingsItem(
        icons: option.icon,
        title: title,
        subtitle: option.description?.call(t),
        trailing: Text(option.value.read(ref)),
        onTap: () async {
          final result = await TextInputDialog.show(
            context,
            title: title,
            initialText: option.value.read(ref),
            maxLength: option.maxLength,
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
