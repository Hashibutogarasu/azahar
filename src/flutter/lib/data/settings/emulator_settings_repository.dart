import '../../native/native_bridge.dart';
import 'clearable.dart';
import 'emulator_setting_key.dart';
import 'settings_value_store.dart';

/// Reads and writes the emulator core's `config.ini`. Every key's meaning, type and default
/// value lives here in Dart; the native side only exposes the raw ini contents.
///
/// Like the original app's `SettingsViewModel`: writes update memory and reload the core right
/// away, but only reach disk once [save] is called.
class EmulatorSettingsRepository implements SettingsValueStore, Clearable {
  EmulatorSettingsRepository(this._nativeBridge);

  final NativeBridge _nativeBridge;
  Map<String, Map<String, String>> _sections = const {};
  bool _dirty = false;

  Future<void> load() async {
    _sections = await _nativeBridge.readEmulatorConfig();
  }

  /// Writes pending changes to `config.ini`. A no-op if nothing changed.
  Future<void> save() async {
    if (!_dirty) return;
    _dirty = false;
    await _nativeBridge.writeEmulatorConfig(_sections);
  }

  @override
  Future<void> clear() async {
    _sections = const {};
    _dirty = false;
    await _nativeBridge.writeEmulatorConfig(_sections);
    await _nativeBridge.reloadEmulatorSettings();
  }

  String? _rawValue(String section, String key) => _sections[section]?[key];

  Future<void> _writeRaw(String section, String key, String value) async {
    _sections = {
      ..._sections,
      section: {...?_sections[section], key: value},
    };
    _dirty = true;
    await _nativeBridge.reloadEmulatorSettings();
  }

  @override
  int readInt(IntKey setting) {
    final raw = _rawValue(setting.section, setting.key);
    if (raw == null) return setting.defaultValue;
    return int.tryParse(raw) ?? setting.defaultValue;
  }

  @override
  Future<void> writeInt(IntKey setting, int value) {
    return _writeRaw(setting.section, setting.key, value.toString());
  }

  @override
  bool readBool(IntBoolKey setting) => readInt(setting) != 0;

  @override
  Future<void> writeBool(IntBoolKey setting, bool value) {
    return writeInt(setting, value ? 1 : 0);
  }

  @override
  double readFloat(FloatKey setting) {
    final raw = _rawValue(setting.section, setting.key);
    final stored = raw == null ? null : double.tryParse(raw);
    final value = stored ?? setting.defaultValue;
    return setting is ScaledFloatKey ? value * setting.scale : value;
  }

  @override
  Future<void> writeFloat(FloatKey setting, double value) {
    final stored = setting is ScaledFloatKey ? value / setting.scale : value;
    return _writeRaw(setting.section, setting.key, stored.toString());
  }

  @override
  String readString(StringKey setting) {
    return _rawValue(setting.section, setting.key) ?? setting.defaultValue;
  }

  @override
  Future<void> writeString(StringKey setting, String value) {
    return _writeRaw(setting.section, setting.key, value);
  }
}
