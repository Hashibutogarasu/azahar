import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../database_files.dart';
import '../user/user_database.dart';
import 'app_data_directory.dart';
import 'repositories/citra_directory_repository.dart';
import 'repositories/first_launch_repository.dart';
import 'repositories/games_directory_repository.dart';
import 'repositories/legacy_user_directory_repository.dart';
import 'repositories/locations_repository.dart';
import 'repositories/master_settings_repository.dart';
import 'repositories/profile_repository.dart';

/// Carries the single database of earlier versions over to the master database: its profiles and
/// app-wide values move to the master database, and each profile gets a copy of it as its user
/// database.
class LegacyDatabaseImport {
  LegacyDatabaseImport(this._profiles, this._locations, this._settings);

  final ProfileRepository _profiles;
  final LocationsRepository _locations;
  final MasterSettingsRepository _settings;

  static const markerFileName = 'user_directory_path.txt';
  static const databaseFileName = 'azahar.sqlite';

  static const _legacyKeys = {
    ProfileRepository.defaultProfileKey: <String>[],
    FirstLaunchRepository.key: ['FirstApplicationLaunch'],
    CitraDirectoryRepository.key: ['CITRA_DIRECTORY'],
    GamesDirectoryRepository.key: <String>[],
    LegacyUserDirectoryRepository.key: <String>[],
  };

  /// Imports the database of an earlier version, if there is one, and removes it afterwards.
  Future<void> run() async {
    final dataDirectory = await AppDataDirectory.resolve();
    final marker = File(p.join(dataDirectory.path, markerFileName));
    final legacy = await _legacyDatabase(dataDirectory, marker);
    if (legacy != null) {
      final contents = _read(legacy);
      await _importSettings(contents.settings);
      await _importProfiles(contents.profiles, legacy);
      await DatabaseFiles.delete(legacy.path);
    }
    if (await marker.exists()) await marker.delete();
  }

  Future<File?> _legacyDatabase(Directory dataDirectory, File marker) async {
    if (await marker.exists()) {
      final configured = (await marker.readAsString()).trim();
      if (configured.isNotEmpty) {
        final file = File(p.join(configured, databaseFileName));
        if (await file.exists()) return file;
      }
    }
    final file = File(p.join(dataDirectory.path, databaseFileName));
    return await file.exists() ? file : null;
  }

  ({Map<String, String> settings, List<Row> profiles}) _read(File file) {
    final database = sqlite3.open(file.path);
    try {
      database.execute('PRAGMA wal_checkpoint(TRUNCATE)');
      final tables = {
        for (final row in database.select(
          "SELECT name FROM sqlite_master WHERE type = 'table'",
        ))
          row['name'] as String,
      };
      final settings = <String, String>{
        if (tables.contains('app_settings'))
          for (final row in database.select(
            'SELECT key, value FROM app_settings',
          ))
            row['key'] as String: row['value'] as String,
      };
      final profiles = tables.contains('profiles')
          ? database
                .select(
                  'SELECT cuid, name, user_directory, games_directory, is_built_in, '
                  'created_at FROM profiles ORDER BY created_at',
                )
                .toList()
          : <Row>[];
      return (settings: settings, profiles: profiles);
    } finally {
      database.close();
    }
  }

  Future<void> _importSettings(Map<String, String> settings) async {
    for (final MapEntry(key: key, value: oldKeys) in _legacyKeys.entries) {
      final value =
          settings[key] ??
          oldKeys.map((oldKey) => settings[oldKey]).nonNulls.firstOrNull;
      if (value != null) await _settings.write(key, value);
    }
  }

  Future<void> _importProfiles(List<Row> rows, File legacy) async {
    final profilesDirectory = await _locations.profilesDirectory();
    if (rows.isEmpty) {
      final pending = File(
        p.join(profilesDirectory.path, UserDatabase.fileName),
      );
      await _copy(legacy, pending);
      await _settings.setPendingUserDatabase(pending.path);
      return;
    }
    for (final row in rows) {
      final profile = await _profiles.create(
        cuid: row['cuid'] as String,
        name: row['name'] as String,
        userDirectory: row['user_directory'] as String,
        gamesDirectory: row['games_directory'] as String?,
        isBuiltIn: row['is_built_in'] == 1,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          (row['created_at'] as int) * 1000,
        ),
      );
      final database = File(
        p.join(profilesDirectory.path, profile.hash, UserDatabase.fileName),
      );
      await _copy(legacy, database);
      await _profiles.updateDirectories(
        profile.cuid,
        databaseFile: database.path,
      );
    }
  }

  Future<void> _copy(File source, File destination) async {
    await destination.parent.create(recursive: true);
    if (await destination.exists()) await destination.delete();
    await source.copy(destination.path);
  }
}
