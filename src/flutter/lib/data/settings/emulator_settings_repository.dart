import '../../native/native_bridge.dart';
import 'emulator_setting_key.dart';

/// Reads and writes the emulator core's `config.ini`, mirroring the original app's
/// `SettingsFile`/`Settings` classes. The native side only exposes the raw ini contents; every
/// key's meaning, type and default value lives here in Dart.
class EmulatorSettingsRepository {
  EmulatorSettingsRepository(this._nativeBridge);

  final NativeBridge _nativeBridge;
  Map<String, Map<String, String>> _sections = const {};

  Future<void> load() async {
    _sections = await _nativeBridge.readEmulatorConfig();
  }

  String? _rawValue(String section, String key) => _sections[section]?[key];

  Future<void> _writeRaw(String section, String key, String value) async {
    _sections = {
      ..._sections,
      section: {...?_sections[section], key: value},
    };
    await _nativeBridge.writeEmulatorConfigValue(section: section, key: key, value: value);
    await _nativeBridge.reloadEmulatorSettings();
  }

  int readInt(IntKey setting) {
    final raw = _rawValue(setting.section, setting.key);
    if (raw == null) return setting.defaultValue;
    return int.tryParse(raw) ?? setting.defaultValue;
  }

  Future<void> writeInt(IntKey setting, int value) {
    return _writeRaw(setting.section, setting.key, value.toString());
  }

  bool readBool(IntBoolKey setting) => readInt(setting) != 0;

  Future<void> writeBool(IntBoolKey setting, bool value) {
    return writeInt(setting, value ? 1 : 0);
  }

  double readFloat(FloatKey setting) {
    final raw = _rawValue(setting.section, setting.key);
    final stored = raw == null ? null : double.tryParse(raw);
    final value = stored ?? setting.defaultValue;
    return setting is ScaledFloatKey ? value * setting.scale : value;
  }

  Future<void> writeFloat(FloatKey setting, double value) {
    final stored = setting is ScaledFloatKey ? value / setting.scale : value;
    return _writeRaw(setting.section, setting.key, stored.toString());
  }

  String readString(StringKey setting) {
    return _rawValue(setting.section, setting.key) ?? setting.defaultValue;
  }

  Future<void> writeString(StringKey setting, String value) {
    return _writeRaw(setting.section, setting.key, value);
  }
}
