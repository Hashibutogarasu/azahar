import 'package:flutter/material.dart';

import '../../data/settings/settings_item.dart';
import '../../i18n/translations.g.dart';
import 'settings_routes.dart';
import 'widgets/settings_list.dart';

/// The settings root menu, mirroring the original app's `SettingsSectionScreen` for
/// `FILE_NAME_CONFIG`: a list of submenus, one per settings section.
class SettingsMenuPage extends StatelessWidget {
  const SettingsMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final items = <SettingsItem>[
      SettingsItem.submenu(
        title: t.settings.general.title,
        onTap: (context) => const GeneralSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.graphics.title,
        onTap: (context) => const GraphicsSettingsRoute().push(context),
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title)),
      body: SettingsList(items: items),
    );
  }
}
