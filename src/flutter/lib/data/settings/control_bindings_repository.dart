import '../database.dart';

class ControlBindingsRepository {
  ControlBindingsRepository(this._db);

  final AppDatabase _db;

  Future<String?> read(String key) async {
    final row = await (_db.select(
      _db.controlBindings,
    )..where((tbl) => tbl.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> write(String key, String value) {
    return _db
        .into(_db.controlBindings)
        .insertOnConflictUpdate(ControlBindingsCompanion.insert(key: key, value: value));
  }
}
