part of '../user_database.dart';

/// Links a game to a tag. A game can have any number of tags.
///
/// [gamePath] is deliberately not a foreign key: the Games table is rebuilt on every rescan and the
/// links must survive that.
@DataClassName('GameTagRow')
class GameTags extends Table {
  TextColumn get gamePath => text()();
  TextColumn get tagId =>
      text().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {gamePath, tagId};
}
