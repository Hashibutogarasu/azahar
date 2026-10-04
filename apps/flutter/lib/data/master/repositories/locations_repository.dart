import 'dart:io';

import 'package:path/path.dart' as p;

import '../app_data_directory.dart';
import '../master_database.dart';

/// The folders the app keeps its data in. A folder that was never stored is stored with its
/// default the first time it is read.
class LocationsRepository {
  LocationsRepository(this._db);

  final MasterDatabase _db;

  static const _system = 'system';
  static const _profiles = 'profiles';

  /// The folder that holds the master database.
  Future<Directory> systemDirectory() async {
    return _directory(_system, () async => (await MasterDatabase.file()).parent.path);
  }

  /// The folder that holds one folder per profile, with the user database of each profile.
  Future<Directory> profilesDirectory() async {
    return _directory(_profiles, () async {
      final system = await systemDirectory();
      return p.join(system.path, AppDataDirectory.profilesName);
    });
  }

  Future<Directory> _directory(
    String kind,
    Future<String> Function() defaultPath,
  ) async {
    final row = await (_db.select(
      _db.locations,
    )..where((tbl) => tbl.kind.equals(kind))).getSingleOrNull();
    if (row != null) return Directory(row.path);
    final path = await defaultPath();
    await _db
        .into(_db.locations)
        .insertOnConflictUpdate(LocationsCompanion.insert(kind: kind, path: path));
    return Directory(path);
  }
}
