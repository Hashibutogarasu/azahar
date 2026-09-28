part of '../database.dart';

class MediaSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  RealColumn get masterVolume => real().withDefault(const Constant(100.0))();

  @override
  Set<Column> get primaryKey => {id};
}
