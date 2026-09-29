part of '../database.dart';

class ThemeSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  IntColumn get staticThemeColor => integer().withDefault(const Constant(0))();
  BoolColumn get blackBackgrounds =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get materialYou => boolean().withDefault(const Constant(false))();
  IntColumn get themeStyle =>
      intEnum<ThemeStyle>().withDefault(Constant(ThemeStyle.azahar.index))();

  @override
  Set<Column> get primaryKey => {id};
}
