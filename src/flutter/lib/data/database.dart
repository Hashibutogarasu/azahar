import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../theme/theme_style.dart';
import 'settings/animation_speed.dart';

part 'database.g.dart';
part 'tables/games.dart';
part 'tables/app_settings.dart';
part 'tables/theme_settings.dart';
part 'tables/accessibility_settings.dart';
part 'tables/advanced_settings.dart';
part 'tables/media_settings.dart';
part 'tables/virtual_access_points.dart';
part 'tables/control_bindings.dart';
part 'tables/input_layout_elements.dart';

@DriftDatabase(
  tables: [
    Games,
    AppSettings,
    ControlBindings,
    InputLayoutElements,
    ThemeSettings,
    AccessibilitySettings,
    AdvancedSettings,
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
  int get schemaVersion => 8;

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
      if (from < 7) {
        await m.createTable(accessibilitySettings);
      }
      if (from < 8) {
        await m.createTable(advancedSettings);
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
