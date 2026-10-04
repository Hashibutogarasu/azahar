part of '../user_database.dart';

class InputLayoutElements extends Table {
  TextColumn get orientation => text()();
  TextColumn get elementId => text()();
  IntColumn get x => integer()();
  IntColumn get y => integer()();
  IntColumn get width => integer()();
  IntColumn get height => integer()();

  @override
  Set<Column> get primaryKey => {orientation, elementId};
}
