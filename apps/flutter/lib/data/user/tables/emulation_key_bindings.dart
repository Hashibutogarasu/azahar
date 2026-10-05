part of '../user_database.dart';

/// The key combination bound to each gamepad action used while a game runs, keyed by the id of
/// the action.
class EmulationKeyBindings extends Table {
  TextColumn get actionId => text()();
  TextColumn get combo => text()();

  @override
  Set<Column> get primaryKey => {actionId};
}
