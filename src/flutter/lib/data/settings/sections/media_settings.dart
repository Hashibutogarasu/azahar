import '../../../i18n/translations.g.dart';
import '../emulator_setting_key.dart';
import '../settings_item.dart';

abstract final class MediaSettingKeys {
  static const treatAudioAsMediaSession = IntBoolKey(
    'Core',
    'treat_audio_as_media_session',
    false,
  );
}

List<SettingsItem> buildMediaSettingsItems(Translations t) {
  final m = t.settings.media;
  return [
    SettingsItem.switch_(
      title: m.treatAudioAsMediaSession,
      description: m.treatAudioAsMediaSessionDescription,
      setting: MediaSettingKeys.treatAudioAsMediaSession,
    ),
  ];
}
