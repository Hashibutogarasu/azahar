import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../routing/app_routes.dart';
import '../../settings/widgets/settings_group_card.dart';

class ControlsOptionsGroup extends StatelessWidget {
  const ControlsOptionsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return SettingsGroupCard(
      settingsGroupTitle: t.options.groups.controls,
      items: [
        babstrap.SettingsItem(
          icons: Icons.sports_esports,
          title: t.settings.gamepad.title,
          onTap: () => const OptionsControlsSettingsRoute().push(context),
        ),
      ],
    );
  }
}
