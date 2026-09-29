import '../../../i18n/translations.g.dart';
import '../emulator_setting_key.dart';
import '../emulator_settings_repository.dart';
import '../settings_item.dart';
import '../settings_value_store.dart';
import 'general_settings.dart';
import 'system_settings.dart';

/// Presents [SystemSettingKeys.lleApplets] inverted, since "use high-level emulation" and
/// "use LLE for applets" are opposites of the same underlying setting.
class HighLevelEmulationValueStore implements SettingsValueStore {
  HighLevelEmulationValueStore(this._repository);

  final EmulatorSettingsRepository _repository;

  @override
  bool readBool(IntBoolKey setting) =>
      !_repository.readBool(SystemSettingKeys.lleApplets);

  @override
  Future<void> writeBool(IntBoolKey setting, bool value) async {
    await _repository.writeBool(SystemSettingKeys.lleApplets, !value);
    await _repository.save();
  }

  @override
  int readInt(IntKey setting) => setting.defaultValue;

  @override
  Future<void> writeInt(IntKey setting, int value) => Future.value();

  @override
  double readFloat(FloatKey setting) => setting.defaultValue;

  @override
  Future<void> writeFloat(FloatKey setting, double value) => Future.value();

  @override
  String readString(StringKey setting) => setting.defaultValue;

  @override
  Future<void> writeString(StringKey setting, String value) => Future.value();
}

List<SettingsItem> buildEmulationSettingsItems(
  Translations t,
  HighLevelEmulationValueStore highLevelEmulationStore,
) {
  final s = t.settings.system;
  final g = t.settings.general;
  final e = t.settings.emulation;
  return [
    SettingsItem.switch_(
      title: s.new3ds,
      description: s.new3dsDescription,
      setting: SystemSettingKeys.new3ds,
    ),
    SettingsItem.switch_(
      title: e.useHighLevelEmulation,
      description: e.useHighLevelEmulationDescription,
      setting: SystemSettingKeys.lleApplets,
      store: highLevelEmulationStore,
    ),
    SettingsItem.switch_(
      title: g.frameLimitEnable,
      description: g.frameLimitEnableDescription,
      setting: GeneralSettingKeys.useFrameLimit,
    ),
    SettingsItem.slider(
      title: g.frameLimitSlider,
      description: g.frameLimitSliderDescription,
      setting: GeneralSettingKeys.frameLimit,
      min: 1,
      max: 200,
      units: '%',
    ),
    SettingsItem.switch_(
      title: s.pluginLoaderEnable,
      description: s.pluginLoaderEnableDescription,
      setting: SystemSettingKeys.pluginLoader,
    ),
    SettingsItem.switch_(
      title: s.allowPluginLoader,
      description: s.allowPluginLoaderDescription,
      setting: SystemSettingKeys.allowPluginLoader,
    ),
  ];
}
