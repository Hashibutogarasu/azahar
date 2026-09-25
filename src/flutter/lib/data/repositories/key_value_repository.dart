import '../database.dart';

abstract class KeyValueRepository {
  KeyValueRepository(this.db);

  final AppDatabase db;

  List<(String oldKey, String newKey)> get keyMigrations => const [];

  Future<void> migrate() async {
    for (final (oldKey, newKey) in keyMigrations) {
      final value = await read(oldKey);
      if (value == null) continue;
      await write(newKey, value);
      await delete(oldKey);
    }
  }

  Future<String?> read(String key) async {
    final row = await (db.select(
      db.appSettings,
    )..where((tbl) => tbl.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> write(String key, String value) {
    return db
        .into(db.appSettings)
        .insertOnConflictUpdate(AppSettingsCompanion.insert(key: key, value: value));
  }

  Future<void> delete(String key) {
    return (db.delete(db.appSettings)..where((tbl) => tbl.key.equals(key))).go();
  }

  Future<bool> readBool(String key, {bool defaultValue = false}) async {
    final value = await read(key);
    if (value == null) return defaultValue;
    return value == 'true';
  }

  Future<void> writeBool(String key, bool value) {
    return write(key, value.toString());
  }
}
