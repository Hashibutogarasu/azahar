part of '../database.dart';

@DataClassName('FeatureFlagSetting')
class FeatureFlags extends Table {
  TextColumn get id => text()();
  BoolColumn get value => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
