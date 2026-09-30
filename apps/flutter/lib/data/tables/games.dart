part of '../database.dart';

@DataClassName('GameRow')
class Games extends Table {
  TextColumn get path => text()();
  TextColumn get filename => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get titleId => integer()();
  TextColumn get company => text()();
  TextColumn get regions => text()();
  BoolColumn get isInstalled => boolean()();
  BoolColumn get isSystemTitle => boolean()();
  BoolColumn get isVisibleSystemTitle => boolean()();
  TextColumn get iconPath => text().nullable()();
  DateTimeColumn get addedToLibraryTime => dateTime().nullable()();
  DateTimeColumn get lastPlayedTime => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {path};
}
