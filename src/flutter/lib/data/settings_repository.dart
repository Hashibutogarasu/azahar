import 'database.dart';

class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Future<String?> read(String key) async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((tbl) => tbl.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> write(String key, String value) {
    return _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(AppSettingsCompanion.insert(key: key, value: value));
  }

  Future<bool> readBool(String key, {bool defaultValue = false}) async {
    final value = await read(key);
    if (value == null) return defaultValue;
    return value == 'true';
  }

  Future<void> writeBool(String key, bool value) {
    return write(key, value.toString());
  }

  Future<bool> isFirstApplicationLaunch() {
    return readBool(SettingsKeys.firstApplicationLaunch, defaultValue: true);
  }

  Future<void> setFirstApplicationLaunchComplete() {
    return writeBool(SettingsKeys.firstApplicationLaunch, false);
  }

  Future<String?> citraDirectoryUri() {
    return read(SettingsKeys.citraDirectory);
  }

  Future<void> setCitraDirectoryUri(String uri) {
    return write(SettingsKeys.citraDirectory, uri);
  }

  Future<String?> gamesDirectoryUri() {
    return read(SettingsKeys.gamePath);
  }

  Future<void> setGamesDirectoryUri(String uri) {
    return write(SettingsKeys.gamePath, uri);
  }

  String? _languageCode;

  String? get languageCode => _languageCode;

  Future<void> loadLanguageCode() async {
    _languageCode = await read(SettingsKeys.languageCode);
  }

  Future<void> setLanguageCode(String? languageCode) async {
    if (languageCode == null) {
      await (_db.delete(
        _db.appSettings,
      )..where((tbl) => tbl.key.equals(SettingsKeys.languageCode))).go();
    } else {
      await write(SettingsKeys.languageCode, languageCode);
    }
    _languageCode = languageCode;
  }

  Future<String?> articBaseAddress() {
    return read(SettingsKeys.articBaseAddress);
  }

  Future<void> setArticBaseAddress(String address) {
    return write(SettingsKeys.articBaseAddress, address);
  }

  bool _useLegacySettingsUI = false;

  /// Whether the Options tab should show the pre-redesign UI instead of the current one.
  bool get useLegacySettingsUI => _useLegacySettingsUI;

  Future<void> loadUseLegacySettingsUI() async {
    _useLegacySettingsUI = await readBool(SettingsKeys.useLegacySettingsUI);
  }

  Future<void> setUseLegacySettingsUI(bool value) async {
    await writeBool(SettingsKeys.useLegacySettingsUI, value);
    _useLegacySettingsUI = value;
  }
}
