import 'package:flutter/material.dart';

import '../../../data/settings/sections/debug_settings.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_list.dart';

class DebugSettingsPage extends StatelessWidget {
  const DebugSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.debug.title)),
      body: SettingsList(items: buildDebugSettingsItems(t)),
    );
  }
}
