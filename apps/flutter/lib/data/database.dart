import 'dart:io';

import 'package:cuid2/cuid2.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../theme/theme_style.dart';
import 'settings/animation_speed.dart';
import 'settings/page_transition_style.dart';
import 'user_directory_bootstrap.dart';

part 'database.g.dart';
part 'tables/games.dart';
part 'tables/app_settings.dart';
part 'tables/theme_settings.dart';
part 'tables/accessibility_settings.dart';
part 'tables/advanced_settings.dart';
part 'tables/media_settings.dart';
part 'tables/debug_settings.dart';
part 'tables/virtual_access_points.dart';
part 'tables/control_bindings.dart';
part 'tables/input_layout_elements.dart';
part 'tables/pinned_options.dart';
part 'tables/option_history_entries.dart';
part 'tables/tags.dart';
part 'tables/game_tags.dart';
part 'tables/user_game_infos.dart';
part 'tables/feature_flags.dart';

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
    DebugSettings,
    VirtualAccessPoints,
    PinnedOptions,
    OptionHistoryEntries,
    Tags,
    GameTags,
    UserGameInfos,
    FeatureFlags,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._(super.e);

  @visibleForTesting
  AppDatabase.forTesting(super.e);

  static AppDatabase? _instance;
  static bool isUsingTemporaryStorage = false;

  factory AppDatabase() {
    return _instance ??= AppDatabase._(_openConnection());
  }

  @override
  int get schemaVersion => 15;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
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
      if (from < 9) {
        await m.createTable(debugSettings);
      }
      if (from < 10) {
        await m.createTable(pinnedOptions);
        await m.createTable(optionHistoryEntries);
      }
      if (from < 11) {
        final columns = await customSelect(
          'PRAGMA table_info(${accessibilitySettings.actualTableName})',
        ).get();
        final hasPageTransition = columns.any(
          (column) =>
              column.read<String>('name') ==
              accessibilitySettings.pageTransition.name,
        );
        if (!hasPageTransition) {
          await m.addColumn(
            accessibilitySettings,
            accessibilitySettings.pageTransition,
          );
        }
      }
      if (from < 12) {
        await m.createTable(tags);
        await m.createTable(gameTags);
      }
      if (from < 13) {
        await m.createTable(userGameInfos);
      }
      if (from < 15) {
        await customStatement('DROP TABLE IF EXISTS feature_flags');
        await m.createTable(featureFlags);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      if (!Platform.isLinux) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File(
          p.join(directory.path, UserDirectoryBootstrap.databaseFileName),
        );
        return NativeDatabase.createInBackground(file);
      }

      final configuredDirectory =
          await UserDirectoryBootstrap.readConfiguredDirectory();
      if (configuredDirectory == null) {
        isUsingTemporaryStorage = true;
        return NativeDatabase.createInBackground(
          await UserDirectoryBootstrap.pendingDatabaseFile(),
        );
      }

      await Directory(configuredDirectory).create(recursive: true);
      final targetFile = File(
        p.join(configuredDirectory, UserDirectoryBootstrap.databaseFileName),
      );
      if (!await targetFile.exists()) {
        final pendingFile = await UserDirectoryBootstrap.pendingDatabaseFile();
        if (await pendingFile.exists()) {
          await UserDirectoryBootstrap.moveDatabaseFiles(
            pendingFile,
            targetFile,
          );
        }
      }
      return NativeDatabase.createInBackground(targetFile);
    });
  }
}
