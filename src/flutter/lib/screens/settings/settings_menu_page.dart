import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../data/settings/reset_settings_provider.dart';
import '../../data/settings/settings_item.dart';
import '../../i18n/translations.g.dart';
import 'settings_routes.dart';
import 'widgets/settings_list.dart';

/// The settings root menu, mirroring the original app's `SettingsSectionScreen` for
/// `FILE_NAME_CONFIG`: a list of submenus, one per settings section.
///
/// Loads `config.ini` on entry and saves it on exit, like `SettingsActivity`.
class SettingsMenuPage extends ConsumerStatefulWidget {
  const SettingsMenuPage({super.key});

  @override
  ConsumerState<SettingsMenuPage> createState() => _SettingsMenuPageState();
}

class _SettingsMenuPageState extends ConsumerState<SettingsMenuPage> {
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
        icon: Icons.tune,
        onTap: (context) => const GeneralSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.system.title,
        icon: Icons.memory,
        onTap: (context) => const SystemSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.camera.title,
        icon: Icons.camera_alt,
        onTap: (context) => const CameraSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.controls.title,
        icon: Icons.sports_esports,
        onTap: (context) => const ControlsSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.graphics.title,
        icon: Icons.monitor,
        onTap: (context) => const GraphicsSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.layout.title,
        icon: Icons.fit_screen,
        onTap: (context) => const LayoutSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.audio.title,
        icon: Icons.volume_up,
        onTap: (context) => const AudioSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.debug.title,
        icon: Icons.code,
        onTap: (context) => const DebugSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.language.title,
        icon: Icons.language,
        onTap: (context) => const LanguageSettingsRoute().push(context),
      ),
      SettingsItem.action(
        title: t.settings.resetToDefault,
        icon: Icons.restore,
        onTap: (context) => _confirmReset(context, t),
      ),
    ];
  }

  Future<void> _confirmReset(BuildContext context, Translations t) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.settings.resetToDefaultDialog.title),
          content: Text(t.settings.resetToDefaultDialog.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(t.settings.resetToDefaultDialog.confirm),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;
    await ref.read(resetSettingsProvider).resetAll();
    setState(() {});
  }
}
