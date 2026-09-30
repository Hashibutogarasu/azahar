import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/options/abstract_base_option.dart';
import '../../../../data/options/translation_lookup.dart';
import '../../../../i18n/translations.g.dart';

/// The tile of an [ActionOption]: a row that runs the option's action when tapped. A destructive
/// action is drawn in the error color.
class ActionOptionTile extends ConsumerWidget {
  const ActionOptionTile({
    super.key,
    required this.option,
    required this.onAccessed,
    required this.onLongPress,
  });

  final ActionOption option;
  final VoidCallback onAccessed;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final descriptionKey = option.descriptionKey;
    final errorColor = Theme.of(context).colorScheme.error;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: onLongPress,
      child: babstrap.SettingsItem(
        icons: option.icon,
        title: t.resolve(option.titleKey),
        subtitle: descriptionKey == null ? null : t.lookup(descriptionKey),
        titleStyle: option.destructive
            ? TextStyle(fontWeight: FontWeight.bold, color: errorColor)
            : null,
        iconStyle: option.destructive
            ? babstrap.IconStyle(iconsColor: errorColor, withBackground: false)
            : null,
        trailing: const SizedBox.shrink(),
        onTap: () async {
          onAccessed();
          await option.onTap(context, ref);
        },
      ),
    );
  }
}
