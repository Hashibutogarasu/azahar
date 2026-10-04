import 'package:drift/drift.dart';

import '../../profiles/profile.dart';
import '../../repositories/deletable.dart';
import '../master_database.dart';
import 'master_key_value_repository.dart';

/// Thrown when a profile is created with the name of an existing profile.
class DuplicateProfileNameException implements Exception {
  const DuplicateProfileNameException(this.name);

  final String name;

  @override
  String toString() => 'A profile named "$name" already exists';
}

/// Stores the profiles and which of them is the default one.
class ProfileRepository extends MasterKeyValueRepository
    implements Deletable<String> {
  ProfileRepository(super.db);

  static const defaultProfileKey = 'default_profile';

  String get _defaultProfileKey => defaultProfileKey;

  /// Every profile, oldest first.
  Future<List<Profile>> profiles() async {
    final rows = await (db.select(
      db.profiles,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)])).get();
    return rows.map(_fromRow).toList();
  }

  /// Watches every profile, oldest first.
  Stream<List<Profile>> watchProfiles() {
    return (db.select(db.profiles)
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<Profile?> profileByCuid(String cuid) async {
    final row = await (db.select(
      db.profiles,
    )..where((tbl) => tbl.cuid.equals(cuid))).getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  Future<Profile?> builtInProfile() async {
    final row =
        await (db.select(db.profiles)
              ..where((tbl) => tbl.isBuiltIn.equals(true))
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  Future<bool> nameExists(String name) async {
    final row = await (db.select(
      db.profiles,
    )..where((tbl) => tbl.name.equals(name))).getSingleOrNull();
    return row != null;
  }

  /// Adds a profile and returns it. [cuid] and [createdAt] are generated unless given, which is
  /// only done when profiles are carried over from an earlier version.
  ///
  /// Throws [DuplicateProfileNameException] when a profile named [name] already exists.
  Future<Profile> create({
    required String name,
    required String userDirectory,
    String? gamesDirectory,
    bool isBuiltIn = false,
    String? cuid,
    DateTime? createdAt,
  }) async {
    if (await nameExists(name)) {
      throw DuplicateProfileNameException(name);
    }
    final row = await db
        .into(db.profiles)
        .insertReturning(
          ProfilesCompanion.insert(
            cuid: Value.absentIfNull(cuid),
            name: name,
            userDirectory: userDirectory,
            gamesDirectory: Value(gamesDirectory),
            isBuiltIn: Value(isBuiltIn),
            createdAt: Value.absentIfNull(createdAt),
          ),
        );
    return _fromRow(row);
  }

  /// Sets the folders and the user database file of the profile [cuid].
  Future<void> updateDirectories(
    String cuid, {
    String? userDirectory,
    String? gamesDirectory,
    String? databaseFile,
  }) {
    return (db.update(
      db.profiles,
    )..where((tbl) => tbl.cuid.equals(cuid))).write(
      ProfilesCompanion(
        userDirectory: Value.absentIfNull(userDirectory),
        gamesDirectory: Value.absentIfNull(gamesDirectory),
        databaseFile: Value.absentIfNull(databaseFile),
      ),
    );
  }

  @override
  Future<void> delete(String cuid) {
    return (db.delete(
      db.profiles,
    )..where((tbl) => tbl.cuid.equals(cuid))).go();
  }

  Future<String?> defaultProfileCuid() => read(_defaultProfileKey);

  Future<void> setDefaultProfileCuid(String cuid) =>
      write(_defaultProfileKey, cuid);

  /// The default profile, or null before any profile exists.
  Future<Profile?> defaultProfile() async {
    final cuid = await defaultProfileCuid();
    return cuid == null ? null : profileByCuid(cuid);
  }

  /// The profile whose user database is open: the default profile, or the built-in profile
  /// before a default is chosen.
  Future<Profile?> activeProfile() async {
    return await defaultProfile() ?? await builtInProfile();
  }

  Profile _fromRow(ProfileRow row) {
    return Profile(
      cuid: row.cuid,
      name: row.name,
      userDirectory: row.userDirectory,
      gamesDirectory: row.gamesDirectory,
      databaseFile: row.databaseFile,
      isBuiltIn: row.isBuiltIn,
      createdAt: row.createdAt,
    );
  }
}
