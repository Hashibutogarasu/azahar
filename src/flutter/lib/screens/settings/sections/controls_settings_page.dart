import 'package:flutter/material.dart';

import '../../../app_services.dart';
import '../../../data/settings/sections/controls_settings.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_list.dart';

class ControlsSettingsPage extends StatelessWidget {
  const ControlsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.gamepad.title)),
      body: SettingsList(
        items: buildControlsSettingsItems(t, AppServices.controlBindingsValueStore),
      ),
    );
  }
}
