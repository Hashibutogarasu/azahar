import 'package:flutter/material.dart';

import '../../../app_services.dart';
import '../../../data/settings/sections/general_settings.dart';
import '../../../data/settings/system_save_value_store.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_list.dart';

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({super.key});

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  late final _store = SystemSaveValueStore(AppServices.systemSaveRepository);

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.general.title)),
      body: SettingsList(items: buildGeneralSettingsItems(t, _store, () => setState(() {}))),
    );
  }
}
