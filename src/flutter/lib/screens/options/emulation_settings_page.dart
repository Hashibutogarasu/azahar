import 'package:flutter/material.dart';

import '../../app_services.dart';
import '../../data/settings/sections/emulation_settings.dart';
import '../../i18n/translations.g.dart';
import '../settings/widgets/settings_list.dart';

class EmulationSettingsPage extends StatelessWidget {
  const EmulationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final store = HighLevelEmulationValueStore(AppServices.emulatorSettingsRepository);
    return Scaffold(
      appBar: AppBar(title: Text(t.options.emulation)),
      body: SettingsList(items: buildEmulationSettingsItems(t, store)),
    );
  }
}
