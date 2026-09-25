import '../../../i18n/translations.g.dart';
import '../emulator_setting_key.dart';
import '../emulator_settings_repository.dart';
import '../settings_item.dart';
import '../settings_value_store.dart';
import 'system_settings.dart';

/// Presents [SystemSettingKeys.lleApplets] and [SystemSettingKeys.requiredOnlineLleModules]
/// together as a single "access network" switch, since both need to be enabled for online
/// features to work.
class NetworkAccessValueStore implements SettingsValueStore {
  NetworkAccessValueStore(this._repository);

  final EmulatorSettingsRepository _repository;

  @override
  bool readBool(IntBoolKey setting) =>
      _repository.readBool(SystemSettingKeys.lleApplets) &&
      _repository.readBool(SystemSettingKeys.requiredOnlineLleModules);

  @override
  Future<void> writeBool(IntBoolKey setting, bool value) async {
    await _repository.writeBool(SystemSettingKeys.lleApplets, value);
    await _repository.writeBool(SystemSettingKeys.requiredOnlineLleModules, value);
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

List<SettingsItem> buildNetworkingSettingsItems(
  Translations t,
  NetworkAccessValueStore networkAccessStore,
) {
  final n = t.settings.networking;
  return [
    SettingsItem.switch_(
      title: n.accessNetwork,
      description: n.accessNetworkDescription,
      setting: SystemSettingKeys.requiredOnlineLleModules,
      store: networkAccessStore,
    ),
    SettingsItem.switch_(
      title: n.useWireless,
      description: n.useWirelessDescription,
      setting: SystemSettingKeys.scanRealWifiNetworks,
    ),
  ];
}
