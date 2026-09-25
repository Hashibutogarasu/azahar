import '../../../i18n/translations.g.dart';
import '../emulator_setting_key.dart';
import '../settings_item.dart';
import '../system_save_value_store.dart';

abstract final class AudioSettingKeys {
  static const volume = ScaledFloatKey('Audio', 'volume', 1.0, 100);
  static const audioStretching = IntBoolKey('Audio', 'enable_audio_stretching', true);
  static const realtimeAudio = IntBoolKey('Audio', 'enable_realtime_audio', false);
  static const audioInputType = IntKey('Audio', 'input_type', 0);
  static const soundOutputMode = IntKey('Audio', 'soundOutputMode', 1);
}

List<SettingsItem> buildAudioSettingsItems(Translations t, SystemSaveValueStore systemSaveStore) {
  final a = t.settings.audio;
  return [
    SettingsItem.floatSlider(
      title: a.volume,
      setting: AudioSettingKeys.volume,
      min: 0,
      max: 100,
      units: '%',
    ),
    SettingsItem.switch_(
      title: a.audioStretching,
      description: a.audioStretchingDescription,
      setting: AudioSettingKeys.audioStretching,
    ),
    SettingsItem.switch_(
      title: a.realtimeAudio,
      description: a.realtimeAudioDescription,
      setting: AudioSettingKeys.realtimeAudio,
    ),
    SettingsItem.singleChoice(
      title: a.audioInputType,
      setting: AudioSettingKeys.audioInputType,
      choiceLabels: [
        a.audioInputTypeAuto,
        a.audioInputTypeNone,
        a.audioInputTypeStaticNoise,
        a.audioInputTypeRealCubeb,
        a.audioInputTypeRealOpenal,
      ],
      choiceValues: const [0, 1, 2, 3, 4],
    ),
    SettingsItem.singleChoice(
      title: a.soundOutputMode,
      setting: AudioSettingKeys.soundOutputMode,
      choiceLabels: [a.soundOutputModeMono, a.soundOutputModeStereo, a.soundOutputModeSurround],
      choiceValues: const [0, 1, 2],
      store: systemSaveStore,
    ),
  ];
}
