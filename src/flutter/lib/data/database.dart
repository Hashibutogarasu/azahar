import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../theme/theme_style.dart';

part 'database.g.dart';

@DataClassName('GameRow')
class Games extends Table {
  TextColumn get path => text()();
  TextColumn get filename => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get titleId => integer()();
  TextColumn get company => text()();
  TextColumn get regions => text()();
  BoolColumn get isInstalled => boolean()();
  BoolColumn get isSystemTitle => boolean()();
  BoolColumn get isVisibleSystemTitle => boolean()();
  TextColumn get iconPath => text().nullable()();
  DateTimeColumn get addedToLibraryTime => dateTime().nullable()();
  DateTimeColumn get lastPlayedTime => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {path};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class ThemeSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  IntColumn get staticThemeColor => integer().withDefault(const Constant(0))();
  BoolColumn get blackBackgrounds => boolean().withDefault(const Constant(false))();
  BoolColumn get materialYou => boolean().withDefault(const Constant(false))();
  IntColumn get themeStyle =>
      intEnum<ThemeStyle>().withDefault(Constant(ThemeStyle.azahar.index))();

  @override
  Set<Column> get primaryKey => {id};
}

class MediaSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  RealColumn get masterVolume => real().withDefault(const Constant(100.0))();

  @override
  Set<Column> get primaryKey => {id};
}

class VirtualAccessPoints extends Table {
  IntColumn get sortIndex => integer()();
  TextColumn get ssid => text()();
  TextColumn get bssid => text()();
  IntColumn get frequency => integer()();
  IntColumn get level => integer()();

  @override
  Set<Column> get primaryKey => {sortIndex};
}

class ControlBindings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class InputLayoutElements extends Table {
  TextColumn get orientation => text()();
  TextColumn get elementId => text()();
  IntColumn get x => integer()();
  IntColumn get y => integer()();
  IntColumn get width => integer()();
  IntColumn get height => integer()();

  @override
  Set<Column> get primaryKey => {orientation, elementId};
}

@DriftDatabase(
  tables: [
    Games,
    AppSettings,
    ControlBindings,
    InputLayoutElements,
    ThemeSettings,
    MediaSettings,
    VirtualAccessPoints,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._(super.e);

  static AppDatabase? _instance;

  factory AppDatabase() {
    return _instance ??= AppDatabase._(_openConnection());
  }

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(controlBindings);
        await m.createTable(inputLayoutElements);
        await m.createTable(themeSettings);
      }
      if (from < 3) {
        await m.createTable(mediaSettings);
      }
      if (from < 4) {
        await m.createTable(virtualAccessPoints);
      }
      if (from < 5) {
        await m.addColumn(themeSettings, themeSettings.themeStyle);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final directory = await getApplicationDocumentsDirectory();
      final file = File(p.join(directory.path, 'azahar.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
