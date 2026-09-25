import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../../data/settings/sections/audio_settings.dart';
import '../../../data/settings/system_save_value_store.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_list.dart';

class AudioSettingsPage extends ConsumerStatefulWidget {
  const AudioSettingsPage({super.key});

  @override
  ConsumerState<AudioSettingsPage> createState() => _AudioSettingsPageState();
}

class _AudioSettingsPageState extends ConsumerState<AudioSettingsPage> {
  late final _systemSaveStore = SystemSaveValueStore(AppServices.systemSaveRepository);

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.audio.title)),
      body: SettingsList(items: buildAudioSettingsItems(t, _systemSaveStore)),
    );
  }
}
