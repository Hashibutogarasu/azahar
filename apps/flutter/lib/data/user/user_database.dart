import 'dart:io';

import 'package:cuid2/cuid2.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';

import '../../theme/theme_style.dart';
import '../settings/animation_speed.dart';
import '../settings/page_transition_style.dart';

part 'user_database.g.dart';
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

/// The data of one profile: its settings, games, tags and controls.
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
class UserDatabase extends _$UserDatabase {
  UserDatabase(File file) : super(_openConnection(file));

  @visibleForTesting
  UserDatabase.forTesting(super.e);

  static const fileName = 'user_data.sqlite';

  static const _masterKeys = [
    'default_profile',
    'first_application_launch',
    'FirstApplicationLaunch',
    'citra_directory',
    'CITRA_DIRECTORY',
    'game_path',
    'legacy_user_directory_decided',
  ];

  @override
  int get schemaVersion => 18;

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
      if (from < 17) {
        await customStatement('DROP TABLE IF EXISTS profiles');
        await (delete(
          appSettings,
        )..where((tbl) => tbl.key.isIn(_masterKeys))).go();
      }
      if (from < 18) {
        await m.addColumn(mediaSettings, mediaSettings.audioEngine);
      }
    },
  );

  static QueryExecutor _openConnection(File file) {
    return LazyDatabase(() async {
      await file.parent.create(recursive: true);
      return NativeDatabase.createInBackground(file);
    });
  }
}
