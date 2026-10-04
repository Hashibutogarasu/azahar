import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;

import '../database_files.dart';
import '../master/repositories/games_directory_repository.dart';
import '../profiles/profile.dart';
import '../repositories/installed_titles_repository.dart';
import 'user_session.dart';

/// Keeps the user database of the active profile open, and never more than one at a time.
///
/// While the app is shown, its widgets read the open database, so opening another profile's
/// database only takes effect on [remount]: the app is taken down first, then the open database
/// is closed, the new one is opened, and the app is built again on it.
class UserSessions {
  UserSessions(this._gamesDirectoryRepository, this._installedTitlesRepository);

  final GamesDirectoryRepository _gamesDirectoryRepository;
  final InstalledTitlesRepository _installedTitlesRepository;
  final Set<String> _deletedFiles = {};
  final ValueNotifier<int> generation = ValueNotifier(0);
  final ValueNotifier<bool> reopening = ValueNotifier(false);
  UserSession? _current;
  Profile? _pending;
  bool _isShown = false;

  /// The session of the active profile.
  UserSession get current =>
      _current ?? (throw StateError('No user database is open'));

  /// Marks that the app is shown, so opening another database waits for [remount].
  void markShown() => _isShown = true;

  /// Opens the user database of [profile] unless it is already open. While the app is shown it is
  /// opened on the next [remount] instead.
  Future<void> open(Profile profile) async {
    if (_isOpen(profile.databaseFile)) {
      _pending = null;
      return;
    }
    if (_isShown && _current != null) {
      _pending = profile;
      return;
    }
    await _reopen(profile);
  }

  /// Deletes the user database of the removed [profile] once it is no longer open, together with
  /// its folder when nothing else is left in it.
  Future<void> deleteWhenClosed(Profile profile) async {
    _deletedFiles.add(profile.databaseFile);
    if (!_isOpen(profile.databaseFile)) await _deleteFiles();
  }

  /// Builds the app again on the user database opened last, if it changed.
  void remount() {
    final pending = _pending;
    if (pending == null) return;
    _pending = null;
    reopening.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _reopen(pending);
      generation.value++;
      reopening.value = false;
    });
  }

  bool _isOpen(String path) {
    final current = _current;
    return current != null && p.equals(current.file.path, path);
  }

  Future<void> _reopen(Profile profile) async {
    final previous = _current;
    _current = null;
    await previous?.database.close();
    final session = UserSession(
      File(profile.databaseFile),
      _gamesDirectoryRepository,
      _installedTitlesRepository,
    );
    await session.migrateKeys();
    _current = session;
    await _deleteFiles();
  }

  Future<void> _deleteFiles() async {
    for (final path in List.of(_deletedFiles)) {
      _deletedFiles.remove(path);
      if (path.isEmpty) continue;
      await DatabaseFiles.delete(path);
      final folder = File(path).parent;
      if (await folder.exists() && await folder.list().isEmpty) {
        await folder.delete();
      }
    }
  }
}
