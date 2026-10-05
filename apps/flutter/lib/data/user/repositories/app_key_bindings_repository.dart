import 'package:drift/drift.dart';

import '../../gamepad/actions/gamepad_action.dart';
import '../../gamepad/key_binding.dart';
import '../user_database.dart';
import 'key_bindings_repository.dart';

/// Stores the key combinations of the actions that operate the app, in [AppKeyBindings].
class AppKeyBindingsRepository extends KeyBindingsRepository {
  AppKeyBindingsRepository(super.db);

  @override
  GamepadActionScope get scope => GamepadActionScope.app;

  AppKeyBindingsCompanion _row(KeyBinding binding) {
    return AppKeyBindingsCompanion.insert(
      profileId: binding.profileId,
      actionId: binding.actionId,
      combo: binding.combo.serialize(),
    );
  }

  @override
  Future<void> create(KeyBinding value) {
    return db
        .into(db.appKeyBindings)
        .insert(_row(value), mode: InsertMode.insertOrIgnore);
  }

  @override
  Future<void> write(KeyBinding value) {
    return db.into(db.appKeyBindings).insertOnConflictUpdate(_row(value));
  }

  @override
  Future<void> delete(String profileId) {
    return (db.delete(
      db.appKeyBindings,
    )..where((tbl) => tbl.profileId.equals(profileId))).go();
  }

  @override
  Future<void> clear() => db.delete(db.appKeyBindings).go();

  @override
  Stream<Map<String, String>> watchRows(String profileId) {
    return (db.select(db.appKeyBindings)
          ..where((tbl) => tbl.profileId.equals(profileId)))
        .watch()
        .map((rows) => {for (final row in rows) row.actionId: row.combo});
  }
}
