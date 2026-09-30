part of '../database.dart';

/// The Options items most recently changed or opened. A larger [accessOrder] is more recent.
class OptionHistoryEntries extends Table {
  TextColumn get optionId => text()();
  IntColumn get accessOrder => integer()();

  @override
  Set<Column> get primaryKey => {optionId};
}
