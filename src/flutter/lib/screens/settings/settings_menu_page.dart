import 'package:flutter/material.dart';

import '../../app_services.dart';
import '../../data/settings/settings_item.dart';
import '../../i18n/translations.g.dart';
import 'settings_routes.dart';
import 'widgets/settings_list.dart';

/// The settings root menu, mirroring the original app's `SettingsSectionScreen` for
/// `FILE_NAME_CONFIG`: a list of submenus, one per settings section.
///
/// Loads `config.ini` on entry and saves it on exit, like `SettingsActivity`.
class SettingsMenuPage extends StatefulWidget {
  const SettingsMenuPage({super.key});

  @override
  State<SettingsMenuPage> createState() => _SettingsMenuPageState();
}

class _SettingsMenuPageState extends State<SettingsMenuPage> {
  late final Future<void> _loaded = AppServices.emulatorSettingsRepository.load();

  @override
  void dispose() {
    AppServices.emulatorSettingsRepository.save();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title)),
      body: FutureBuilder<void>(
        future: _loaded,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return SettingsList(items: _buildMenuItems(t));
        },
      ),
    );
  }

  List<SettingsItem> _buildMenuItems(Translations t) {
    return [
      SettingsItem.submenu(
        title: t.settings.general.title,
        onTap: (context) => const GeneralSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.graphics.title,
        onTap: (context) => const GraphicsSettingsRoute().push(context),
      ),
    ];
  }
}
