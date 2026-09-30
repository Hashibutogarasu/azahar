import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../data/settings/reset_settings_provider.dart';
import '../../data/settings/settings_item.dart';
import '../../data/settings/settings_load_provider.dart';
import '../../i18n/translations.g.dart';
import '../../widgets/confirmation_dialog.dart';
import 'settings_routes.dart';
import 'widgets/settings_list.dart';

/// The pre-redesign settings root menu, kept only for the legacy Options UI
/// (`useLegacySettingsUI`). The current UI reaches every section directly from the Options
/// page instead of through this hub.
@Deprecated(
  'Superseded by the Options page groups. Kept for the legacy Options UI only.',
)
class LegacySettingsMenuPage extends ConsumerStatefulWidget {
  const LegacySettingsMenuPage({super.key});

  @override
  ConsumerState<LegacySettingsMenuPage> createState() =>
      _LegacySettingsMenuPageState();
}

class _LegacySettingsMenuPageState
    extends ConsumerState<LegacySettingsMenuPage> {
  @override
  void dispose() {
    AppServices.emulatorSettingsRepository.save();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    ref.watch(settingsLoadProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title)),
      body: SettingsList(items: _buildMenuItems(t)),
    );
  }

  List<SettingsItem> _buildMenuItems(Translations t) {
    return [
      SettingsItem.submenu(
        title: t.settings.general.title,
        icon: Icons.tune,
        onTap: (context) => const LegacyGeneralSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.system.title,
        icon: Icons.memory,
        // ignore: deprecated_member_use_from_same_package
        onTap: (context) => const LegacySystemSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.camera.title,
        icon: Icons.camera_alt,
        onTap: (context) => const LegacyCameraSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.gamepad.title,
        icon: Icons.sports_esports,
        onTap: (context) => const LegacyControlsSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.graphics.title,
        icon: Icons.monitor,
        onTap: (context) => const LegacyGraphicsSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.layout.title,
        icon: Icons.fit_screen,
        onTap: (context) => const LegacyLayoutSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.audio.title,
        icon: Icons.volume_up,
        // ignore: deprecated_member_use_from_same_package
        onTap: (context) => const LegacyAudioSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.debug.title,
        icon: Icons.code,
        onTap: (context) => const LegacyDebugSettingsRoute().push(context),
      ),
      SettingsItem.submenu(
        title: t.settings.language.title,
        icon: Icons.language,
        onTap: (context) => const LegacyLanguageSettingsRoute().push(context),
      ),
      SettingsItem.action(
        title: t.settings.resetToDefault,
        icon: Icons.restore,
        onTap: (context) => _confirmReset(context, t),
      ),
    ];
  }

  Future<void> _confirmReset(BuildContext context, Translations t) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: t.settings.resetToDefaultDialog.title,
      message: t.settings.resetToDefaultDialog.message,
      confirmLabel: t.settings.resetToDefaultDialog.confirm,
    );
    if (!confirmed) return;
    await ref.read(resetSettingsProvider).resetAll();
    setState(() {});
  }
}
