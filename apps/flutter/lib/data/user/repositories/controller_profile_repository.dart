import 'package:drift/drift.dart';

import '../../gamepad/controller_profile.dart';
import '../../gamepad/new_controller_profile.dart';
import '../../repositories/clearable.dart';
import '../../repositories/creatable.dart';
import '../../repositories/deletable.dart';
import '../user_database.dart';

/// Stores the controller profiles. [create] adds one, [delete] removes the one with a cuid unless
/// it is built in, and [clear] removes every profile that is not built in. It is only used through
/// the `ControllerSettingsRepository`, which also takes care of their key bindings.
class ControllerProfileRepository
    implements
        Creatable<NewControllerProfile, ControllerProfile>,
        Deletable<String>,
        Clearable {
  ControllerProfileRepository(this.db);

  final UserDatabase db;

  /// Every profile, oldest first.
  Future<List<ControllerProfile>> profiles() async {
    final rows = await (db.select(
      db.controllerProfiles,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)])).get();
    return rows.map(_fromRow).toList();
  }

  /// Every profile, oldest first, and again whenever they change.
  Stream<List<ControllerProfile>> watchProfiles() {
    return (db.select(db.controllerProfiles)
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<ControllerProfile?> builtInProfile() async {
    final row =
        await (db.select(db.controllerProfiles)
              ..where((tbl) => tbl.isBuiltIn.equals(true))
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<ControllerProfile> create(NewControllerProfile value) async {
    final row = await db
        .into(db.controllerProfiles)
        .insertReturning(
          ControllerProfilesCompanion.insert(
            name: value.name,
            isBuiltIn: Value(value.isBuiltIn),
          ),
        );
    return _fromRow(row);
  }

  @override
  Future<void> delete(String cuid) {
    return (db.delete(db.controllerProfiles)
          ..where((tbl) => tbl.cuid.equals(cuid) & tbl.isBuiltIn.equals(false)))
        .go();
  }

  @override
  Future<void> clear() {
    return (db.delete(
      db.controllerProfiles,
    )..where((tbl) => tbl.isBuiltIn.equals(false))).go();
  }

  ControllerProfile _fromRow(ControllerProfileRow row) {
    return ControllerProfile(
      cuid: row.cuid,
      name: row.name,
      isBuiltIn: row.isBuiltIn,
      createdAt: row.createdAt,
    );
  }
}
