import 'package:drift/drift.dart';

import '../database.dart';

/// Stores the ids of the Options items the user pinned, in the order they were pinned.
class PinnedOptionsRepository {
  PinnedOptionsRepository(this.db);

  /// The most items that can be pinned at once.
  static const int maxPinned = 10;

  final AppDatabase db;

  Future<List<String>> readAll() async {
    final rows = await (db.select(
      db.pinnedOptions,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.sortIndex)])).get();
    return rows.map((row) => row.optionId).toList();
  }

  /// Pins [optionId] after the existing pins.
  ///
  /// Returns false, without changing anything, when [maxPinned] items are already pinned. Pinning
  /// an item that is already pinned succeeds and keeps its position.
  Future<bool> pin(String optionId) {
    return db.transaction(() async {
      final pinned = await readAll();
      if (pinned.contains(optionId)) return true;
      if (pinned.length >= maxPinned) return false;
      await db
          .into(db.pinnedOptions)
          .insert(
            PinnedOptionsCompanion.insert(
              optionId: optionId,
              sortIndex: pinned.length,
            ),
          );
      return true;
    });
  }

  /// Unpins every item.
  Future<void> clear() => db.delete(db.pinnedOptions).go();

  Future<void> unpin(String optionId) {
    return db.transaction(() async {
      await (db.delete(
        db.pinnedOptions,
      )..where((tbl) => tbl.optionId.equals(optionId))).go();
      final remaining = await readAll();
      for (var i = 0; i < remaining.length; i++) {
        await (db.update(db.pinnedOptions)
              ..where((tbl) => tbl.optionId.equals(remaining[i])))
            .write(PinnedOptionsCompanion(sortIndex: Value(i)));
      }
    });
  }
}
