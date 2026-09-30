import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/options/abstract_base_option.dart';
import '../../../../data/options/option_values_revision_provider.dart';
import '../../../../data/options/translation_lookup.dart';
import '../../../../i18n/translations.g.dart';
import '../../../settings/widgets/toggle_settings_item.dart';
import 'option_commit.dart';

/// The tile of a [BoolOption]: a switch row.
class BoolOptionTile extends ConsumerWidget {
  const BoolOptionTile({
    super.key,
    required this.option,
    required this.onAccessed,
    required this.onLongPress,
  });

  final BoolOption option;
  final VoidCallback onAccessed;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(optionValuesRevisionProvider);
    final t = context.t;
    final descriptionKey = option.descriptionKey;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: onLongPress,
      child: ToggleSettingsItem(
        icon: option.icon,
        title: t.resolve(option.titleKey),
        subtitle: descriptionKey == null ? null : t.lookup(descriptionKey),
        value: option.value.read(ref),
        onChanged: (value) =>
            ref.commitOptionValue(context, option.value, value, onAccessed),
      ),
    );
  }
}
