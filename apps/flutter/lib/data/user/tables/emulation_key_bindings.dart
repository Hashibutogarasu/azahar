part of '../user_database.dart';

/// The key combination bound to each gamepad action used while a game runs, keyed by the
/// controller profile it belongs to and the id of the action.
class EmulationKeyBindings extends Table {
  TextColumn get profileId => text()();
  TextColumn get actionId => text()();
  TextColumn get combo => text()();

  @override
  Set<Column> get primaryKey => {profileId, actionId};
}
