import 'package:drift/drift.dart';

import '../database.dart';

class MediaSettingsRepository {
  MediaSettingsRepository(this._db);

  final AppDatabase _db;

  Future<MediaSetting> read() async {
    final row = await (_db.select(
      _db.mediaSettings,
    )..where((tbl) => tbl.id.equals(0))).getSingleOrNull();
    return row ?? const MediaSetting(id: 0, masterVolume: 100.0);
  }

  Future<void> write(MediaSetting settings) {
    return _db
        .into(_db.mediaSettings)
        .insertOnConflictUpdate(settings.toCompanion(true).copyWith(id: const Value(0)));
  }
}
