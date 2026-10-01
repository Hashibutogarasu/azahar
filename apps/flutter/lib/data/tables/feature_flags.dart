part of '../database.dart';

class FeatureFlags extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  BoolColumn get performanceImprovements =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
