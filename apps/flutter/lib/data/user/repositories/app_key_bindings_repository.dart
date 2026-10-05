import 'package:drift/drift.dart';

import '../../gamepad/actions/gamepad_action.dart';
import '../user_database.dart';
import 'key_bindings_repository.dart';

/// Stores the key combinations of the actions that operate the app, in [AppKeyBindings].
class AppKeyBindingsRepository extends KeyBindingsRepository {
  AppKeyBindingsRepository(super.db, super.registry);

  @override
  GamepadActionScope get scope => GamepadActionScope.app;

  @override
  Future<void> insertIfAbsent(String actionId, String combo) {
    return db
        .into(db.appKeyBindings)
        .insert(
          AppKeyBindingsCompanion.insert(actionId: actionId, combo: combo),
          mode: InsertMode.insertOrIgnore,
        );
  }

  @override
  Future<void> upsert(String actionId, String combo) {
    return db
        .into(db.appKeyBindings)
        .insertOnConflictUpdate(
          AppKeyBindingsCompanion.insert(actionId: actionId, combo: combo),
        );
  }

  @override
  Future<void> deleteExcept(Iterable<String> actionIds) {
    return (db.delete(
      db.appKeyBindings,
    )..where((tbl) => tbl.actionId.isNotIn(actionIds))).go();
  }

  @override
  Future<void> deleteAll() => db.delete(db.appKeyBindings).go();

  @override
  Stream<Map<String, String>> watchRows() {
    return db
        .select(db.appKeyBindings)
        .watch()
        .map((rows) => {for (final row in rows) row.actionId: row.combo});
  }
}
