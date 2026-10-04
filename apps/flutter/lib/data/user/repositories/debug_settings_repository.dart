import 'package:drift/drift.dart';

import '../user_database.dart';

class DebugSettingsRepository {
  DebugSettingsRepository(this._db);

  final UserDatabase _db;

  Future<DebugSetting> read() async {
    final row = await (_db.select(
      _db.debugSettings,
    )..where((tbl) => tbl.id.equals(0))).getSingleOrNull();
    return row ?? const DebugSetting(id: 0, logToConsole: true);
  }

  Future<void> write(DebugSetting settings) {
    return _db
        .into(_db.debugSettings)
        .insertOnConflictUpdate(
          settings.toCompanion(true).copyWith(id: const Value(0)),
        );
  }
}
