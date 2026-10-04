part of '../master_database.dart';

/// App-wide values that do not belong to a profile, such as the default profile.
@DataClassName('MasterSettingRow')
class MasterSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
