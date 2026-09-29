part of '../database.dart';

class DebugSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  BoolColumn get logToConsole =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
