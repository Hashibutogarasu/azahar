import 'package:babstrap_settings_screen/babstrap_settings_screen.dart' as babstrap;
import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../routing/app_routes.dart';
import '../../settings/widgets/settings_group_card.dart';

class GraphicsOptionsGroup extends StatelessWidget {
  const GraphicsOptionsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return SettingsGroupCard(
      settingsGroupTitle: t.options.groups.graphics,
      items: [
        babstrap.SettingsItem(
          icons: Icons.monitor,
          title: t.settings.graphics.title,
          onTap: () => const OptionsGraphicsSettingsRoute().push(context),
        ),
        babstrap.SettingsItem(
          icons: Icons.fit_screen,
          title: t.settings.layout.title,
          onTap: () => const OptionsLayoutSettingsRoute().push(context),
        ),
        babstrap.SettingsItem(
          icons: Icons.camera_alt,
          title: t.settings.camera.title,
          onTap: () => const OptionsCameraSettingsRoute().push(context),
        ),
      ],
    );
  }
}
