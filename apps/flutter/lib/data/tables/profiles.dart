part of '../database.dart';

String _newProfileCuid() => cuid();

/// A user profile: the location of its user folder and its games folder.
///
/// [cuid] is generated on insert and identifies the profile. [name] is shown to the user and is
/// unique. [userDirectory] is the URI of the folder that holds the profile's data, and
/// [gamesDirectory] the folder that is scanned for games, if one was chosen.
@DataClassName('ProfileRow')
class Profiles extends Table {
  TextColumn get cuid => text().clientDefault(_newProfileCuid)();
  TextColumn get name => text().unique()();
  TextColumn get userDirectory => text()();
  TextColumn get gamesDirectory => text().nullable()();
  BoolColumn get isBuiltIn => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {cuid};
}
