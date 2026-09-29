part of '../database.dart';

class VirtualAccessPoints extends Table {
  IntColumn get sortIndex => integer()();
  TextColumn get ssid => text()();
  TextColumn get bssid => text()();
  IntColumn get frequency => integer()();
  IntColumn get level => integer()();

  @override
  Set<Column> get primaryKey => {sortIndex};
}
