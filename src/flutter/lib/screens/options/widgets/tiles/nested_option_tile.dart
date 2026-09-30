import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';

import '../../../../data/options/abstract_base_option.dart';
import '../../../../i18n/translations.g.dart';

/// The tile of a [NestedOption]: a row that opens the option's destination page.
class NestedOptionTile extends StatelessWidget {
  const NestedOptionTile({
    super.key,
    required this.option,
    required this.onAccessed,
    required this.onLongPress,
  });

  final NestedOption option;
  final VoidCallback onAccessed;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: onLongPress,
      child: babstrap.SettingsItem(
        icons: option.icon,
        title: option.title(t),
        subtitle: option.description?.call(t),
        onTap: () {
          onAccessed();
          option.destination.push(context);
        },
      ),
    );
  }
}
