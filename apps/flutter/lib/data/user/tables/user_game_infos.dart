part of '../user_database.dart';

/// Information about a game that the user edited, keyed by the game id.
///
/// The game id is deliberately not a foreign key: the Games table is rebuilt on every rescan and
/// the edits must survive that.
@DataClassName('UserGameInfoRow')
class UserGameInfos extends Table {
  TextColumn get gameId => text()();
  TextColumn get name => text().nullable()();

  @override
  Set<Column> get primaryKey => {gameId};
}
