import '../master_database.dart';

/// Reads and writes app-wide values in the master database.
abstract class MasterKeyValueRepository {
  MasterKeyValueRepository(this.db);

  final MasterDatabase db;

  Future<String?> read(String key) async {
    final row = await (db.select(
      db.masterSettings,
    )..where((tbl) => tbl.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> write(String key, String value) {
    return db
        .into(db.masterSettings)
        .insertOnConflictUpdate(
          MasterSettingsCompanion.insert(key: key, value: value),
        );
  }

  Future<void> deleteKey(String key) {
    return (db.delete(
      db.masterSettings,
    )..where((tbl) => tbl.key.equals(key))).go();
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
