import '../user/repositories/control_bindings_repository.dart';
import '../repositories/loadable.dart';
import 'emulator_setting_key.dart';
import 'settings_value_store.dart';

class ControlBindingsValueStore implements SettingsValueStore, Loadable {
  ControlBindingsValueStore(this._repository);

  final ControlBindingsRepository _repository;
  Map<String, String> _values = const {};

  @override
  Future<void> load() async {
    _values = await _repository.readAll();
  }

  @override
  String readString(StringKey setting) =>
      _values[setting.key] ?? setting.defaultValue;

  @override
  Future<void> writeString(StringKey setting, String value) async {
    await _repository.write(setting.key, value);
    _values = {..._values, setting.key: value};
  }

  @override
  int readInt(IntKey setting) => setting.defaultValue;

  @override
  Future<void> writeInt(IntKey setting, int value) => Future.value();

  @override
  bool readBool(IntBoolKey setting) => setting.defaultValue != 0;

  @override
  Future<void> writeBool(IntBoolKey setting, bool value) => Future.value();

  @override
  double readFloat(FloatKey setting) => setting.defaultValue;

  @override
  Future<void> writeFloat(FloatKey setting, double value) => Future.value();
}
