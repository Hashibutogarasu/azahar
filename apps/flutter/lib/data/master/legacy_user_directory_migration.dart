import 'dart:io';

import 'package:path/path.dart' as p;

import '../database_files.dart';
import '../file_moves.dart';
import 'app_data_directory.dart';
import 'legacy_database_import.dart';
import 'master_database.dart';

/// Moves the core data left directly in the app data folder [root] into a profile folder,
/// through `/tmp/azahar/migrations`.
class LegacyUserDirectoryMigration {
  LegacyUserDirectoryMigration(this.root, {Directory? temporary})
    : temporary =
          temporary ??
          Directory(p.join(Directory.systemTemp.path, 'azahar', 'migrations'));

  final Directory root;
  final Directory temporary;

  static const _coreDirectories = ['nand', 'sdmc', 'sysdata', 'config'];

  static final _appEntries = {
    LegacyDatabaseImport.markerFileName,
    ...DatabaseFiles.names(LegacyDatabaseImport.databaseFileName),
    ...DatabaseFiles.names(MasterDatabase.fileName),
    AppDataDirectory.profilesName,
  };

  /// Whether [root] still holds core data.
  Future<bool> hasLegacyData() async {
    for (final name in _coreDirectories) {
      final directory = Directory(p.join(root.path, name));
      if (await directory.exists() && !await directory.list().isEmpty) {
        return true;
      }
    }
    return false;
  }

  /// Whether a previous migration stopped before restoring.
  Future<bool> isInterrupted() async {
    return await temporary.exists() && !await temporary.list().isEmpty;
  }

  /// Moves the core data into the profile folder [destination].
  Future<void> migrate(String destination) async {
    await temporary.create(recursive: true);
    if (await root.exists()) {
      for (final entry in await root.list(followLinks: false).toList()) {
        final name = p.basename(entry.path);
        if (_appEntries.contains(name)) continue;
        await FileMoves.move(entry, p.join(temporary.path, name));
      }
    }
    await Directory(
      p.join(root.path, AppDataDirectory.profilesName),
    ).create(recursive: true);
    await Directory(destination).create(recursive: true);
    for (final entry in await temporary.list(followLinks: false).toList()) {
      await FileMoves.move(entry, p.join(destination, p.basename(entry.path)));
    }
    await temporary.delete(recursive: true);
    final parent = temporary.parent;
    if (await parent.exists() && await parent.list().isEmpty) {
      await parent.delete();
    }
  }
}
