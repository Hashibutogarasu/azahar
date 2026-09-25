import 'package:flutter/material.dart';

import '../../../app_services.dart';
import '../../../data/settings/sections/networking_settings.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_list.dart';

class NetworkingSettingsPage extends StatelessWidget {
  const NetworkingSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final store = NetworkAccessValueStore(AppServices.emulatorSettingsRepository);
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.networking.title)),
      body: SettingsList(items: buildNetworkingSettingsItems(t, store)),
    );
  }
}
