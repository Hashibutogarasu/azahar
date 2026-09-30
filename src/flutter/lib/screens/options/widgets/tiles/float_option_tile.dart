import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/options/abstract_base_option.dart';
import '../../../../data/options/option_values_revision_provider.dart';
import '../../../../data/options/translation_lookup.dart';
import '../../../../i18n/translations.g.dart';
import '../../../settings/dialogs/slider_value_dialog.dart';
import 'option_commit.dart';

/// The tile of a [FloatOption]: shows the value rounded and opens a slider dialog to change it.
class FloatOptionTile extends ConsumerWidget {
  const FloatOptionTile({
    super.key,
    required this.option,
    required this.onAccessed,
    required this.onLongPress,
  });

  final FloatOption option;
  final VoidCallback onAccessed;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(optionValuesRevisionProvider);
    final t = context.t;
    final title = t.resolve(option.titleKey);
    final descriptionKey = option.descriptionKey;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: onLongPress,
      child: babstrap.SettingsItem(
        icons: option.icon,
        title: title,
        subtitle: descriptionKey == null ? null : t.lookup(descriptionKey),
        trailing: Text('${option.value.read(ref).round()}${option.units}'),
        onTap: () async {
          final result = await SliderValueDialog.show(
            context,
            title: title,
            min: option.min.round(),
            max: option.max.round(),
            units: option.units,
            initialValue: option.value.read(ref).round(),
            defaultValue: option.defaultValue.round(),
          );
          if (result == null || !context.mounted) return;
          await ref.commitOptionValue(
            context,
            option.value,
            result.toDouble(),
            onAccessed,
          );
        },
      ),
    );
  }
}
