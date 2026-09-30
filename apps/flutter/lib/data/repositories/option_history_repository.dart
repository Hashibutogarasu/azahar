import 'package:drift/drift.dart';

import '../database.dart';

/// Stores the Options items most recently changed or opened, separately from the pinned items.
class OptionHistoryRepository {
  OptionHistoryRepository(this.db);

  /// The most entries kept; older ones are dropped as new ones are recorded.
  static const int maxEntries = 5;

  final AppDatabase db;

  /// Returns the ids of the recorded items, most recent first.
  Future<List<String>> readRecent() async {
    final rows = await (db.select(
      db.optionHistoryEntries,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.accessOrder)])).get();
    return rows.map((row) => row.optionId).toList();
  }

  /// Forgets [optionId] only.
  Future<void> remove(String optionId) {
    return (db.delete(
      db.optionHistoryEntries,
    )..where((tbl) => tbl.optionId.equals(optionId))).go();
  }

  /// Forgets every recorded item.
  Future<void> clear() => db.delete(db.optionHistoryEntries).go();

  /// Records that [optionId] was just changed or opened, moving it to the front if it was
  /// already recorded.
  Future<void> record(String optionId) {
    return db.transaction(() async {
      final newest =
          await (db.select(db.optionHistoryEntries)
                ..orderBy([(tbl) => OrderingTerm.desc(tbl.accessOrder)])
                ..limit(1))
              .getSingleOrNull();
      await db
          .into(db.optionHistoryEntries)
          .insertOnConflictUpdate(
            OptionHistoryEntriesCompanion.insert(
              optionId: optionId,
              accessOrder: (newest?.accessOrder ?? 0) + 1,
            ),
          );
      final recent = await readRecent();
      for (final staleId in recent.skip(maxEntries)) {
        await (db.delete(
          db.optionHistoryEntries,
        )..where((tbl) => tbl.optionId.equals(staleId))).go();
      }
    });
  }
}
