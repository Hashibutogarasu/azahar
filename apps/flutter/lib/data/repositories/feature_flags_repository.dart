import '../database.dart';
import 'loadable.dart';
import 'writable.dart';

/// Holds whether each feature flag is on in memory, keyed by flag id, so they can be read
/// synchronously once [load] has completed. A flag that was never written is off.
class FeatureFlagsRepository implements Loadable, Writable<FeatureFlagSetting> {
  FeatureFlagsRepository(this._db);

  final AppDatabase _db;

  final Map<String, bool> _values = {};

  bool valueOf(String id) => _values[id] ?? false;

  @override
  Future<void> load() async {
    final rows = await _db.select(_db.featureFlags).get();
    _values
      ..clear()
      ..addEntries(rows.map((row) => MapEntry(row.id, row.value)));
  }

  @override
  Future<void> write(FeatureFlagSetting value) async {
    await _db
        .into(_db.featureFlags)
        .insertOnConflictUpdate(value.toCompanion(true));
    _values[value.id] = value.value;
  }
}
