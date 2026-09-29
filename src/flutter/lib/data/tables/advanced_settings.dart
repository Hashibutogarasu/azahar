part of '../database.dart';

class AdvancedSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get animationSpeed => intEnum<AnimationSpeed>().withDefault(
    Constant(AnimationSpeed.normal.index),
  )();

  @override
  Set<Column> get primaryKey => {id};
}
