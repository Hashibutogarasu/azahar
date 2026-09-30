part of '../database.dart';

/// The Options items the user pinned, in the order they were pinned.
class PinnedOptions extends Table {
  TextColumn get optionId => text()();
  IntColumn get sortIndex => integer()();

  @override
  Set<Column> get primaryKey => {optionId};
}
