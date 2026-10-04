part of '../user_database.dart';

/// The tags that can be attached to games.
///
/// [id] is a cuid generated on insert. [kind] holds the name of a persisted `TagKind`.
@DataClassName('TagRow')
class Tags extends Table {
  TextColumn get id => text().clientDefault(() => cuid())();
  TextColumn get kind => text().unique()();
  IntColumn get sortIndex => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
