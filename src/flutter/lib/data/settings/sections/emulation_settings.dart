import '../../../i18n/translations.g.dart';
import '../emulator_setting_key.dart';
import '../emulator_settings_repository.dart';
import '../settings_item.dart';
import '../settings_value_store.dart';
import 'system_settings.dart';

/// Presents [SystemSettingKeys.lleApplets] inverted, since "use high-level emulation" and
/// "use LLE for applets" are opposites of the same underlying setting.
class HighLevelEmulationValueStore implements SettingsValueStore {
  HighLevelEmulationValueStore(this._repository);

  final EmulatorSettingsRepository _repository;

  @override
  bool readBool(IntBoolKey setting) => !_repository.readBool(SystemSettingKeys.lleApplets);

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
  ];
}
