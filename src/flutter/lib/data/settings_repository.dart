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

  Future<String?> languageCode() {
    return read(SettingsKeys.languageCode);
  }

  Future<void> setLanguageCode(String? languageCode) {
    if (languageCode == null) {
      return (_db.delete(
        _db.appSettings,
      )..where((tbl) => tbl.key.equals(SettingsKeys.languageCode))).go();
    }
    return write(SettingsKeys.languageCode, languageCode);
  }

  Future<String?> articBaseAddress() {
    return read(SettingsKeys.articBaseAddress);
  }

  Future<void> setArticBaseAddress(String address) {
    return write(SettingsKeys.articBaseAddress, address);
  }
}
