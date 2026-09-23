import 'package:flutter/material.dart';

import '../../../data/settings/sections/general_settings.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_list.dart';

class GeneralSettingsPage extends StatelessWidget {
  const GeneralSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.general.title)),
      body: SettingsList(items: buildGeneralSettingsItems(t)),
    );
  }
}
