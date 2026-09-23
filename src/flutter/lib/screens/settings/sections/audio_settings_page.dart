import 'package:flutter/material.dart';

import '../../../app_services.dart';
import '../../../data/settings/sections/audio_settings.dart';
import '../../../data/settings/system_save_value_store.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_list.dart';

class AudioSettingsPage extends StatefulWidget {
  const AudioSettingsPage({super.key});

  @override
  State<AudioSettingsPage> createState() => _AudioSettingsPageState();
}

class _AudioSettingsPageState extends State<AudioSettingsPage> {
  late final SystemSaveValueStore _store;
  late final Future<void> _loaded;

  @override
  void initState() {
    super.initState();
    _store = SystemSaveValueStore(AppServices.systemSaveRepository);
    _loaded = AppServices.systemSaveRepository.load();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.audio.title)),
      body: FutureBuilder<void>(
        future: _loaded,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return SettingsList(items: buildAudioSettingsItems(t, _store));
        },
      ),
    );
  }
}
