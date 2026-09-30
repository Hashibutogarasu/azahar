import 'package:drift/drift.dart';

import '../database.dart';
import '../settings/page_transition_style.dart';

class AccessibilitySettingsRepository {
  AccessibilitySettingsRepository(this._db);

  final AppDatabase _db;

  Future<AccessibilitySetting> read() async {
    final row = await (_db.select(
      _db.accessibilitySettings,
    )..where((tbl) => tbl.id.equals(0))).getSingleOrNull();
    return row ??
        const AccessibilitySetting(
          id: 0,
          reduceMotion: false,
          pageTransition: PageTransitionStyle.slide,
        );
  }

  Future<void> write(AccessibilitySetting settings) {
    return _db
        .into(_db.accessibilitySettings)
        .insertOnConflictUpdate(
          settings.toCompanion(true).copyWith(id: const Value(0)),
        );
  }
}
