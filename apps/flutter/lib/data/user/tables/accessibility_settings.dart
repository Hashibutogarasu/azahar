part of '../user_database.dart';

class AccessibilitySettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  BoolColumn get reduceMotion => boolean().withDefault(const Constant(false))();
  IntColumn get pageTransition => intEnum<PageTransitionStyle>().withDefault(
    Constant(PageTransitionStyle.slide.index),
  )();

  @override
  Set<Column> get primaryKey => {id};
}
