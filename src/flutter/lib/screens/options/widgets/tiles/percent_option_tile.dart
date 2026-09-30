import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/options/abstract_base_option.dart';
import '../../../../data/options/option_values_revision_provider.dart';
import '../../../../i18n/translations.g.dart';
import '../../../settings/dialogs/slider_value_dialog.dart';
import 'option_commit.dart';

/// The tile of a [PercentOption]: shows the fraction as a percentage and opens a slider dialog,
/// limited to the option's range, to change it.
class PercentOptionTile extends ConsumerWidget {
  const PercentOptionTile({
    super.key,
    required this.option,
    required this.onAccessed,
    required this.onLongPress,
  });

  static const _units = '%';

  final PercentOption option;
  final VoidCallback onAccessed;
  final VoidCallback onLongPress;

  static int _toPercent(double fraction) => (fraction * 100).round();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(optionValuesRevisionProvider);
    final t = context.t;
    final title = option.title(t);
    final percent = _toPercent(option.value.read(ref));
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: onLongPress,
      child: babstrap.SettingsItem(
        icons: option.icon,
        title: title,
        subtitle: option.description?.call(t),
        trailing: Text('$percent$_units'),
        onTap: () async {
          final result = await SliderValueDialog.show(
            context,
            title: title,
            min: _toPercent(option.min),
            max: _toPercent(option.max),
            units: _units,
            initialValue: percent,
            defaultValue: _toPercent(option.defaultValue),
          );
          if (result == null || !context.mounted) return;
          await ref.commitOptionValue(
            context,
            option.value,
            result / 100,
            onAccessed,
          );
        },
      ),
    );
  }
}
