import 'package:drift/drift.dart';

import '../database.dart';

class ThemeSettingsRepository {
  ThemeSettingsRepository(this._db);

  final AppDatabase _db;

  Future<ThemeSetting> read() async {
    final row = await (_db.select(
      _db.themeSettings,
    )..where((tbl) => tbl.id.equals(0))).getSingleOrNull();
    return row ??
        const ThemeSetting(
          id: 0,
          themeMode: 'system',
          staticThemeColor: 0,
          blackBackgrounds: false,
          materialYou: false,
        );
  }

  Future<void> write(ThemeSetting settings) {
    return _db
        .into(_db.themeSettings)
        .insertOnConflictUpdate(
          settings.toCompanion(true).copyWith(id: const Value(0)),
        );
  }
}
