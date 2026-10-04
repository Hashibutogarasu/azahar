import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../../app_services.dart';
import '../../settings/audio_engine_provider.dart';
import '../../settings/media_volume_provider.dart';
import '../../settings/sections/audio_settings.dart';
import '../../settings/sections/media_settings.dart';
import '../../settings/system_save_value_store.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';
import '../store_option_values.dart';

/// The items of the media settings page, which is not listed on the Options page: the app's media
/// session and master volume, and the emulator's audio settings.
final mediaOptionsProvider = Provider<OptionCategory>((ref) {
  final systemSaveStore = SystemSaveValueStore(
    AppServices.systemSaveRepository,
  );
  return OptionCategory(
    id: 'media',
    title: (t) => t.settings.media.title,
    sections: [
      OptionSection(
        title: (t) => t.settings.media.groupApp,
        options: [
          BoolOption(
            title: (t) => t.settings.media.treatAudioAsMediaSession,
            description: (t) =>
                t.settings.media.treatAudioAsMediaSessionDescription,
            icon: Icons.music_note_outlined,
            value: const StoreBoolValue(
              MediaSettingKeys.treatAudioAsMediaSession,
            ),
          ),
          PercentOption(
            title: (t) => t.settings.media.masterVolume,
            description: (t) => t.settings.media.masterVolumeDescription,
            icon: Icons.volume_up_outlined,
            value: CallbackOptionValue<double>(
              onRead: (ref) => ref.watch(masterVolumeProvider) / 100,
              onWrite: (context, ref, value) async {
                final notifier = ref.read(masterVolumeProvider.notifier);
                await notifier.setVolume(value * 100);
                await notifier.persistVolume();
              },
            ),
            defaultValue: 1.0,
            preview: (ref, value) =>
                ref.read(masterVolumeProvider.notifier).setVolume(value * 100),
          ),
          EnumOption<AudioEngine>(
            title: (t) => t.settings.media.audioEngine,
            description: (t) => t.settings.media.audioEngineDescription,
            icon: Icons.graphic_eq,
            value: CallbackOptionValue<AudioEngine>(
              onRead: (ref) => ref.watch(audioEngineProvider),
              onWrite: (context, ref, value) =>
                  ref.read(audioEngineProvider.notifier).select(value),
            ),
            choices: [
              for (final engine in availableAudioEngines())
                EnumChoice(
                  label: (t) => switch (engine) {
                    AudioEngine.openAl => t.settings.media.audioEngineOpenal,
                    AudioEngine.oboe => t.settings.media.audioEngineOboe,
                  },
                  value: engine,
                ),
            ],
          ),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.media.groupEmulator,
        options: [
          PercentOption(
            title: (t) => t.settings.audio.volume,
            description: (t) => t.settings.audio.volumeDescription,
            icon: Icons.volume_up,
            value: const FloatPercentValue(
              StoreFloatValue(AudioSettingKeys.volume),
            ),
            defaultValue: 1.0,
          ),
          BoolOption(
            title: (t) => t.settings.audio.audioStretching,
            description: (t) => t.settings.audio.audioStretchingDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(AudioSettingKeys.audioStretching),
          ),
          BoolOption(
            title: (t) => t.settings.audio.realtimeAudio,
            description: (t) => t.settings.audio.realtimeAudioDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(AudioSettingKeys.realtimeAudio),
          ),
          EnumOption<int>(
            title: (t) => t.settings.audio.audioInputType,
            icon: Icons.mic_none,
            value: const StoreIntValue(AudioSettingKeys.audioInputType),
            choices: [
              EnumChoice(
                label: (t) => t.settings.audio.audioInputTypeAuto,
                value: 0,
              ),
              EnumChoice(
                label: (t) => t.settings.audio.audioInputTypeNone,
                value: 1,
              ),
              EnumChoice(
                label: (t) => t.settings.audio.audioInputTypeStaticNoise,
                value: 2,
              ),
              EnumChoice(
                label: (t) => t.settings.audio.audioInputTypeRealCubeb,
                value: 3,
              ),
              EnumChoice(
                label: (t) => t.settings.audio.audioInputTypeRealOpenal,
                value: 4,
              ),
            ],
          ),
          EnumOption<int>(
            title: (t) => t.settings.audio.soundOutputMode,
            icon: Icons.speaker_group_outlined,
            value: StoreIntValue(
              AudioSettingKeys.soundOutputMode,
              store: systemSaveStore,
            ),
            choices: [
              EnumChoice(
                label: (t) => t.settings.audio.soundOutputModeMono,
                value: 0,
              ),
              EnumChoice(
                label: (t) => t.settings.audio.soundOutputModeStereo,
                value: 1,
              ),
              EnumChoice(
                label: (t) => t.settings.audio.soundOutputModeSurround,
                value: 2,
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
