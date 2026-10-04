import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;

import '../database_files.dart';
import '../master/repositories/games_directory_repository.dart';
import '../profiles/profile.dart';
import '../repositories/installed_titles_repository.dart';
import 'user_session.dart';

/// Keeps the user database of the active profile open.
///
/// Opening another profile's database does not close the previous one right away, since the
/// widgets still built on it may read it until the app is rebuilt by [remount].
class UserSessions {
  UserSessions(this._gamesDirectoryRepository, this._installedTitlesRepository);

  final GamesDirectoryRepository _gamesDirectoryRepository;
  final InstalledTitlesRepository _installedTitlesRepository;
  final List<UserSession> _retired = [];
  final Set<String> _deletedFiles = {};
  UserSession? _current;
  final ValueNotifier<int> generation = ValueNotifier(0);

  /// The session of the active profile.
  UserSession get current =>
      _current ?? (throw StateError('No user database is open'));

  /// Opens the user database of [profile] unless it is already open.
  Future<void> open(Profile profile) async {
    final file = File(profile.databaseFile);
    final previous = _current;
    if (previous != null && p.equals(previous.file.path, file.path)) return;
    final session = UserSession(
      file,
      _gamesDirectoryRepository,
      _installedTitlesRepository,
    );
    await session.migrateKeys();
    _current = session;
    if (previous != null) _retired.add(previous);
  }

  /// Writes a copy of the active user database to [file].
  Future<void> copyCurrentTo(File file) => current.database.copyTo(file);

  /// Deletes the user database of the removed [profile] once it is no longer open, together with
  /// its folder when nothing else is left in it.
  Future<void> deleteWhenClosed(Profile profile) async {
    _deletedFiles.add(profile.databaseFile);
    if (!_retired.any((session) => p.equals(session.file.path, profile.databaseFile))) {
      await _deleteFiles();
    }
  }

  /// Rebuilds the app on the active user database, then closes the databases it no longer uses.
  void remount() {
    generation.value++;
    WidgetsBinding.instance.addPostFrameCallback((_) => _closeRetired());
  }

  Future<void> _closeRetired() async {
    final retired = List.of(_retired);
    _retired.clear();
    for (final session in retired) {
      await session.database.close();
    }
    await _deleteFiles();
  }

  Future<void> _deleteFiles() async {
    for (final path in List.of(_deletedFiles)) {
      if (path.isEmpty) {
        _deletedFiles.remove(path);
        continue;
      }
      await DatabaseFiles.delete(path);
      final folder = File(path).parent;
      if (await folder.exists() && await folder.list().isEmpty) {
        await folder.delete();
      }
      _deletedFiles.remove(path);
    }
  }
}
