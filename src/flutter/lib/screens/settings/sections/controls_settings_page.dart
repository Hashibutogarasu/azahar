import 'package:flutter/material.dart';

import '../../../app_services.dart';
import '../../../data/settings/control_bindings_value_store.dart';
import '../../../data/settings/sections/controls_settings.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_list.dart';

class ControlsSettingsPage extends StatefulWidget {
  const ControlsSettingsPage({super.key});

  @override
  State<ControlsSettingsPage> createState() => _ControlsSettingsPageState();
}

class _ControlsSettingsPageState extends State<ControlsSettingsPage> {
  late final ControlBindingsValueStore _store;
  late final Future<void> _loaded;

  @override
  void initState() {
    super.initState();
    _store = ControlBindingsValueStore(AppServices.controlBindingsRepository);
    _loaded = _store.load();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.controls.title)),
      body: FutureBuilder<void>(
        future: _loaded,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return SettingsList(items: buildControlsSettingsItems(t, _store));
        },
      ),
    );
  }
}
