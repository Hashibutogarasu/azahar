import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../settings/media_volume_provider.dart';
import '../../settings/sections/audio_settings.dart';
import '../../settings/sections/media_settings.dart';
import '../../settings/system_save_value_store.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';
import '../store_option_values.dart';

/// The items of the media settings page, which is not listed on the Options page: the app's media session and master volume, and the emulator's audio
/// settings.
final mediaOptionsProvider = Provider<OptionCategory>((ref) {
  final systemSaveStore = SystemSaveValueStore(
    AppServices.systemSaveRepository,
  );
  return OptionCategory(
    id: 'media',
    titleKey: 'settings.media.title',
    sections: [
      OptionSection(
        titleKey: 'settings.media.groupApp',
        options: [
          const BoolOption(
            titleKey: 'settings.media.treatAudioAsMediaSession',
            descriptionKey:
                'settings.media.treatAudioAsMediaSessionDescription',
            icon: Icons.music_note_outlined,
            value: StoreBoolValue(MediaSettingKeys.treatAudioAsMediaSession),
          ),
          FloatOption(
            titleKey: 'settings.media.masterVolume',
            descriptionKey: 'settings.media.masterVolumeDescription',
            icon: Icons.volume_up_outlined,
            value: CallbackOptionValue<double>(
              onRead: (ref) => ref.watch(masterVolumeProvider),
              onWrite: (context, ref, value) async {
                final notifier = ref.read(masterVolumeProvider.notifier);
                await notifier.setVolume(value);
                await notifier.persistVolume();
              },
            ),
            min: 0,
            max: 100,
            defaultValue: 100,
            units: '%',
          ),
        ],
      ),
      OptionSection(
        titleKey: 'settings.media.groupEmulator',
        options: [
          const FloatOption(
            titleKey: 'settings.audio.volume',
            descriptionKey: 'settings.audio.volumeDescription',
            icon: Icons.volume_up,
            value: StoreFloatValue(AudioSettingKeys.volume),
            min: 0,
            max: 100,
            defaultValue: 100,
            units: '%',
          ),
          const BoolOption(
            titleKey: 'settings.audio.audioStretching',
            descriptionKey: 'settings.audio.audioStretchingDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(AudioSettingKeys.audioStretching),
          ),
          const BoolOption(
            titleKey: 'settings.audio.realtimeAudio',
            descriptionKey: 'settings.audio.realtimeAudioDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(AudioSettingKeys.realtimeAudio),
          ),
          const EnumOption<int>(
            titleKey: 'settings.audio.audioInputType',
            icon: Icons.mic_none,
            value: StoreIntValue(AudioSettingKeys.audioInputType),
            choices: [
              EnumChoice(
                labelKey: 'settings.audio.audioInputTypeAuto',
                value: 0,
              ),
              EnumChoice(
                labelKey: 'settings.audio.audioInputTypeNone',
                value: 1,
              ),
              EnumChoice(
                labelKey: 'settings.audio.audioInputTypeStaticNoise',
                value: 2,
              ),
              EnumChoice(
                labelKey: 'settings.audio.audioInputTypeRealCubeb',
                value: 3,
              ),
              EnumChoice(
                labelKey: 'settings.audio.audioInputTypeRealOpenal',
                value: 4,
              ),
            ],
          ),
          EnumOption<int>(
            titleKey: 'settings.audio.soundOutputMode',
            icon: Icons.speaker_group_outlined,
            value: StoreIntValue(
              AudioSettingKeys.soundOutputMode,
              store: systemSaveStore,
            ),
            choices: const [
              EnumChoice(
                labelKey: 'settings.audio.soundOutputModeMono',
                value: 0,
              ),
              EnumChoice(
                labelKey: 'settings.audio.soundOutputModeStereo',
                value: 1,
              ),
              EnumChoice(
                labelKey: 'settings.audio.soundOutputModeSurround',
                value: 2,
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
