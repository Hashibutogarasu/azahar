import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../../data/settings/media_volume_provider.dart';
import '../../../data/settings/sections/audio_settings.dart';
import '../../../data/settings/sections/media_settings.dart';
import '../../../data/settings/settings_item.dart';
import '../../../data/settings/system_save_value_store.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_list.dart';
import '../widgets/slider_settings_card.dart';

class MediaSettingsPage extends ConsumerStatefulWidget {
  const MediaSettingsPage({super.key});

  @override
  ConsumerState<MediaSettingsPage> createState() => _MediaSettingsPageState();
}

class _MediaSettingsPageState extends ConsumerState<MediaSettingsPage> {
  late final _systemSaveStore = SystemSaveValueStore(
    AppServices.systemSaveRepository,
  );

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final volume = ref.watch(masterVolumeProvider);
    final volumeNotifier = ref.read(masterVolumeProvider.notifier);
    final appItems = <SettingsItem>[
      SettingsItem.header(title: t.settings.media.groupApp),
      ...buildMediaSettingsItems(t),
    ];
    final emulatorItems = <SettingsItem>[
      SettingsItem.header(title: t.settings.media.groupEmulator),
      ...buildAudioSettingsItems(t, _systemSaveStore),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.media.title)),
      body: ListView(
        children: [
          SettingsList(items: appItems, shrinkWrap: true),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SliderSettingsCard(
              title: t.settings.media.masterVolume,
              valueLabel: t.settings.media.masterVolumePercent(
                value: volume.round(),
              ),
              description: t.settings.media.masterVolumeDescription,
              value: volume,
              min: 0,
              max: 100,
              onChanged: volumeNotifier.setVolume,
              onChangeEnd: (_) => volumeNotifier.persistVolume(),
            ),
          ),
          SettingsList(items: emulatorItems, shrinkWrap: true),
        ],
      ),
    );
  }
}
