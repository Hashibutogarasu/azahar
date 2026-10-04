import 'package:drift/drift.dart';

import '../user_database.dart';
import '../../settings/animation_speed.dart';

class AdvancedSettingsRepository {
  AdvancedSettingsRepository(this._db);

  final UserDatabase _db;

  Future<AdvancedSetting> read() async {
    final row = await (_db.select(
      _db.advancedSettings,
    )..where((tbl) => tbl.id.equals(0))).getSingleOrNull();
    return row ??
        const AdvancedSetting(id: 0, animationSpeed: AnimationSpeed.normal);
  }

  Future<void> write(AdvancedSetting settings) {
    return _db
        .into(_db.advancedSettings)
        .insertOnConflictUpdate(
          settings.toCompanion(true).copyWith(id: const Value(0)),
        );
  }
}
