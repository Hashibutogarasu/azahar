import 'package:flutter/material.dart';

import '../../../data/settings/sections/system_settings.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_list.dart';

class SystemSettingsPage extends StatelessWidget {
  const SystemSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.system.title)),
      body: SettingsList(items: buildSystemSettingsItems(t)),
    );
  }
}
