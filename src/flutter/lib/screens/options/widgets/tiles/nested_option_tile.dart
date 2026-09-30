import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';

import '../../../../data/options/abstract_base_option.dart';
import '../../../../data/options/translation_lookup.dart';
import '../../../../i18n/translations.g.dart';

/// The tile of a [NestedOption]: a row that opens the option's destination page. The option is
/// reported as used only once the user comes back from that page, so the history does not change
/// under the page transition.
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
    final descriptionKey = option.descriptionKey;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: onLongPress,
      child: babstrap.SettingsItem(
        icons: option.icon,
        title: t.resolve(option.titleKey),
        subtitle: descriptionKey == null ? null : t.lookup(descriptionKey),
        onTap: () async {
          await option.destination.push(context);
          onAccessed();
        },
      ),
    );
  }
}
