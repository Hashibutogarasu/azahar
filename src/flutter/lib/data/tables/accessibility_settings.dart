part of '../database.dart';

class AccessibilitySettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  BoolColumn get reduceMotion => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
