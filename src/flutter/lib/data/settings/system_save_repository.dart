import '../../native/native_bridge.dart';

class SystemSaveRepository {
  SystemSaveRepository(this._nativeBridge);

  final NativeBridge _nativeBridge;
  Map<String, Object?> _fields = const {};

  Future<void> load() async {
    _fields = await _nativeBridge.readSystemSaveGame();
  }

  String get username => _fields['username'] as String? ?? '';

  Future<void> setUsername(String value) {
    return _writeAndReload({'username': value});
  }

  int get birthdayMonth => (_fields['birthdayMonth'] as num?)?.toInt() ?? 1;

  int get birthdayDay => (_fields['birthdayDay'] as num?)?.toInt() ?? 1;

  Future<void> setBirthday({int? month, int? day}) {
    return _writeAndReload({'birthdayMonth': month, 'birthdayDay': day});
  }

  int get systemLanguage => (_fields['systemLanguage'] as num?)?.toInt() ?? 1;

  Future<void> setSystemLanguage(int value) {
    return _writeAndReload({'systemLanguage': value});
  }

  int get soundOutputMode => (_fields['soundOutputMode'] as num?)?.toInt() ?? 1;

  Future<void> setSoundOutputMode(int value) {
    return _writeAndReload({'soundOutputMode': value});
  }

  int get countryCode => (_fields['countryCode'] as num?)?.toInt() ?? 49;

  Future<void> setCountryCode(int value) {
    return _writeAndReload({'countryCode': value});
  }

  int get playCoins => (_fields['playCoins'] as num?)?.toInt() ?? 42;

  Future<void> setPlayCoins(int value) {
    return _writeAndReload({'playCoins': value});
  }

  String get consoleId => _fields['consoleId'] as String? ?? '';

  Future<void> regenerateConsoleId() async {
    final value = await _nativeBridge.regenerateConsoleId();
    _fields = {..._fields, 'consoleId': value};
  }

  String get mac => _fields['mac'] as String? ?? '';

  Future<void> regenerateMac() async {
    final value = await _nativeBridge.regenerateMac();
    _fields = {..._fields, 'mac': value};
  }

  Future<int> getCountryCompatibility(int region) {
    return _nativeBridge.getCountryCompatibility(region);
  }

  Future<void> _writeAndReload(Map<String, Object?> fields) async {
    await _nativeBridge.writeSystemSaveGame(fields);
    await load();
  }
}
