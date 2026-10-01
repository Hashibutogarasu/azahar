import 'package:drift/drift.dart';

import '../database.dart';
import 'loadable.dart';
import 'writable.dart';

/// Holds the feature flags in memory, so they can be read synchronously once [load] has completed.
class FeatureFlagsRepository implements Loadable, Writable<FeatureFlagSetting> {
  FeatureFlagsRepository(this._db);

  final AppDatabase _db;

  FeatureFlagSetting _flags = const FeatureFlagSetting(
    id: 0,
    performanceImprovements: false,
  );

  FeatureFlagSetting get flags => _flags;

  @override
  Future<void> load() async {
    final row = await (_db.select(
      _db.featureFlags,
    )..where((tbl) => tbl.id.equals(0))).getSingleOrNull();
    if (row != null) _flags = row;
  }

  @override
  Future<void> write(FeatureFlagSetting value) async {
    await _db
        .into(_db.featureFlags)
        .insertOnConflictUpdate(
          value.toCompanion(true).copyWith(id: const Value(0)),
        );
    _flags = value;
  }
}
