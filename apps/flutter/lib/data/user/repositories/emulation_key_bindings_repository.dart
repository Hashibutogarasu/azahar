import 'package:drift/drift.dart';

import '../../gamepad/actions/gamepad_action.dart';
import '../user_database.dart';
import 'key_bindings_repository.dart';

/// Stores the key combinations of the actions used while a game runs, in [EmulationKeyBindings].
class EmulationKeyBindingsRepository extends KeyBindingsRepository {
  EmulationKeyBindingsRepository(super.db, super.registry);

  @override
  GamepadActionScope get scope => GamepadActionScope.emulation;

  @override
  Future<void> insertIfAbsent(String actionId, String combo) {
    return db
        .into(db.emulationKeyBindings)
        .insert(
          EmulationKeyBindingsCompanion.insert(
            actionId: actionId,
            combo: combo,
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  @override
  Future<void> upsert(String actionId, String combo) {
    return db
        .into(db.emulationKeyBindings)
        .insertOnConflictUpdate(
          EmulationKeyBindingsCompanion.insert(
            actionId: actionId,
            combo: combo,
          ),
        );
  }

  @override
  Future<void> deleteExcept(Iterable<String> actionIds) {
    return (db.delete(
      db.emulationKeyBindings,
    )..where((tbl) => tbl.actionId.isNotIn(actionIds))).go();
  }

  @override
  Future<void> deleteAll() => db.delete(db.emulationKeyBindings).go();

  @override
  Stream<Map<String, String>> watchRows() {
    return db
        .select(db.emulationKeyBindings)
        .watch()
        .map((rows) => {for (final row in rows) row.actionId: row.combo});
  }
}
