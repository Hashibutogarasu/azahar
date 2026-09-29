import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../routing/app_routes.dart';
import '../../settings/widgets/settings_group_card.dart';

class AccessibilityOptionsGroup extends StatelessWidget {
  const AccessibilityOptionsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return SettingsGroupCard(
      settingsGroupTitle: t.options.groups.accessibility,
      items: [
        babstrap.SettingsItem(
          icons: Icons.accessibility_new_outlined,
          title: t.options.accessibility,
          subtitle: t.options.accessibilityDescription,
          onTap: () => const OptionsAccessibilitySettingsRoute().push(context),
        ),
      ],
    );
  }
}
