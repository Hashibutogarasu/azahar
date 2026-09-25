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

class MediaSettingsPage extends ConsumerStatefulWidget {
  const MediaSettingsPage({super.key});

  @override
  ConsumerState<MediaSettingsPage> createState() => _MediaSettingsPageState();
}

class _MediaSettingsPageState extends ConsumerState<MediaSettingsPage> {
  late final _systemSaveStore = SystemSaveValueStore(AppServices.systemSaveRepository);

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final volume = ref.watch(masterVolumeProvider);
    final items = <SettingsItem>[
      ...buildMediaSettingsItems(t),
      SettingsItem.header(title: t.settings.audio.title),
      ...buildAudioSettingsItems(t, _systemSaveStore),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.media.title)),
      body: ListView(
        children: [
          SettingsList(items: items, shrinkWrap: true),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _MasterVolumeCard(volume: volume),
          ),
        ],
      ),
    );
  }
}

class _MasterVolumeCard extends ConsumerWidget {
  const _MasterVolumeCard({required this.volume});

  final double volume;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final notifier = ref.read(masterVolumeProvider.notifier);
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t.settings.media.masterVolume, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(t.settings.media.masterVolumePercent(value: volume.round())),
              ],
            ),
            Text(t.settings.media.masterVolumeDescription, style: Theme.of(context).textTheme.bodyMedium),
            Slider(
              value: volume.clamp(0, 100),
              min: 0,
              max: 100,
              onChanged: (value) => notifier.setVolume(value),
              onChangeEnd: (_) => notifier.persistVolume(),
            ),
          ],
        ),
      ),
    );
  }
}
