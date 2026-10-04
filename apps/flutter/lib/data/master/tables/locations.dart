part of '../master_database.dart';

/// The folders the app keeps its data in, by [kind].
@DataClassName('LocationRow')
class Locations extends Table {
  TextColumn get kind => text()();
  TextColumn get path => text()();

  @override
  Set<Column> get primaryKey => {kind};
}
