import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Resolves where the app database lives before a user directory has been confirmed, and moves
/// it there once one is.
abstract final class UserDirectoryBootstrap {
  static const _markerFileName = 'user_directory_path.txt';
  static const _pendingDirName = 'azahar_pending_setup';
  static const databaseFileName = 'azahar.sqlite';

  static Future<String?> readConfiguredDirectory() async {
    final marker = await _markerFile();
    if (!await marker.exists()) return null;
    final path = (await marker.readAsString()).trim();
    return path.isEmpty ? null : path;
  }

  static Future<void> writeConfiguredDirectory(String path) async {
    final marker = await _markerFile();
    await marker.writeAsString(path);
  }

  static Future<File> pendingDatabaseFile() async {
    final tempDirectory = await getTemporaryDirectory();
    final pendingDirectory = Directory(
      p.join(tempDirectory.path, _pendingDirName),
    );
    await pendingDirectory.create(recursive: true);
    return File(p.join(pendingDirectory.path, databaseFileName));
  }

  static Future<void> moveDatabaseFiles(File from, File to) async {
    for (final suffix in const ['', '-wal', '-shm']) {
      final source = File('${from.path}$suffix');
      if (await source.exists()) {
        await _moveFile(source, File('${to.path}$suffix'));
      }
    }
  }

  static Future<void> _moveFile(File source, File destination) async {
    try {
      await source.rename(destination.path);
    } on FileSystemException {
      await source.copy(destination.path);
      await source.delete();
    }
  }

  /// Deletes the pending database if no user directory was ever confirmed. Safe to call
  /// unconditionally.
  static Future<void> cleanupIfUnconfigured() async {
    if (await readConfiguredDirectory() != null) return;
    final pendingDirectory = (await pendingDatabaseFile()).parent;
    if (await pendingDirectory.exists()) {
      await pendingDirectory.delete(recursive: true);
    }
  }

  static Future<File> _markerFile() async {
    final supportDirectory = await getApplicationSupportDirectory();
    return File(p.join(supportDirectory.path, _markerFileName));
  }
}
