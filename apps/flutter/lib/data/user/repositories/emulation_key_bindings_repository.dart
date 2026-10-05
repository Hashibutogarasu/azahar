import 'package:drift/drift.dart';

import '../../gamepad/actions/gamepad_action.dart';
import '../../gamepad/key_binding.dart';
import '../user_database.dart';
import 'key_bindings_repository.dart';

/// Stores the key combinations of the actions used while a game runs, in [EmulationKeyBindings].
class EmulationKeyBindingsRepository extends KeyBindingsRepository {
  EmulationKeyBindingsRepository(super.db);

  @override
  GamepadActionScope get scope => GamepadActionScope.emulation;

  EmulationKeyBindingsCompanion _row(KeyBinding binding) {
    return EmulationKeyBindingsCompanion.insert(
      profileId: binding.profileId,
      actionId: binding.actionId,
      combo: binding.combo.serialize(),
    );
  }

  @override
  Future<void> create(KeyBinding value) {
    return db
        .into(db.emulationKeyBindings)
        .insert(_row(value), mode: InsertMode.insertOrIgnore);
  }

  @override
  Future<void> write(KeyBinding value) {
    return db.into(db.emulationKeyBindings).insertOnConflictUpdate(_row(value));
  }

  @override
  Future<void> delete(String profileId) {
    return (db.delete(
      db.emulationKeyBindings,
    )..where((tbl) => tbl.profileId.equals(profileId))).go();
  }

  @override
  Future<void> clear() => db.delete(db.emulationKeyBindings).go();

  @override
  Stream<Map<String, String>> watchRows(String profileId) {
    return (db.select(db.emulationKeyBindings)
          ..where((tbl) => tbl.profileId.equals(profileId)))
        .watch()
        .map((rows) => {for (final row in rows) row.actionId: row.combo});
  }
}
