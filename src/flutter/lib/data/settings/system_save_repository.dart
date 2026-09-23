import '../../native/native_bridge.dart';
import 'clearable.dart';

class SystemSaveRepository implements Clearable {
  SystemSaveRepository(this._nativeBridge);

  final NativeBridge _nativeBridge;
  Map<String, Object?> _fields = const {};

  static const List<int> countryCodes = [
    1, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
    31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 64, 65,
    66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89,
    90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110,
    111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 136,
    144, 145, 152, 153, 154, 155, 156, 160, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 184,
    185, 186,
  ];

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

  @override
  Future<void> clear() {
    return _writeAndReload({
      'username': 'AZAHAR',
      'birthdayMonth': 11,
      'birthdayDay': 7,
      'systemLanguage': 1,
      'soundOutputMode': 1,
      'countryCode': 49,
      'playCoins': 42,
    });
  }
}
