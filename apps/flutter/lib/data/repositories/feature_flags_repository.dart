import 'package:drift/drift.dart';

import '../database.dart';
import 'loadable.dart';
import 'writable.dart';

/// Holds the feature flags in memory, so they can be read synchronously once [load] has completed.
class FeatureFlagsRepository implements Loadable, Writable<FeatureFlag> {
  FeatureFlagsRepository(this._db);

  final AppDatabase _db;

  FeatureFlag _flags = const FeatureFlag(id: 0, performanceImprovements: false);

  FeatureFlag get flags => _flags;

  @override
  Future<void> load() async {
    final row = await (_db.select(
      _db.featureFlags,
    )..where((tbl) => tbl.id.equals(0))).getSingleOrNull();
    if (row != null) _flags = row;
  }

  @override
  Future<void> write(FeatureFlag value) async {
    await _db
        .into(_db.featureFlags)
        .insertOnConflictUpdate(
          value.toCompanion(true).copyWith(id: const Value(0)),
        );
    _flags = value;
  }
}
