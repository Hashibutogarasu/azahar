import 'package:flutter/material.dart';

// ignore: deprecated_member_use_from_same_package
import '../../../data/settings/sections/system_settings.dart'
    show buildSystemSettingsItems;
import '../../../i18n/translations.g.dart';
import '../widgets/settings_list.dart';

/// The pre-redesign System settings page. The current UI splits this content between the
/// Emulation and System categories instead; kept only for the legacy Options UI
/// (`useLegacySettingsUI`).
@Deprecated('Only used by the legacy Options UI.')
class LegacySystemSettingsPage extends StatelessWidget {
  const LegacySystemSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.system.title)),
      // ignore: deprecated_member_use_from_same_package
      body: SettingsList(items: buildSystemSettingsItems(t)),
    );
  }
}
