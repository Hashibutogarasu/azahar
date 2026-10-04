import 'package:drift/drift.dart';

import '../database.dart';
import '../profiles/profile.dart';
import 'deletable.dart';
import 'key_value_repository.dart';

/// Thrown when a profile is created with the name of an existing profile.
class DuplicateProfileNameException implements Exception {
  const DuplicateProfileNameException(this.name);

  final String name;

  @override
  String toString() => 'A profile named "$name" already exists';
}

/// Stores the profiles and which of them is the default one.
class ProfileRepository extends KeyValueRepository implements Deletable<String> {
  ProfileRepository(super.db);

  final String _defaultProfileKey = 'default_profile';

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

  /// Adds a profile and returns it with its generated cuid.
  ///
  /// Throws [DuplicateProfileNameException] when a profile named [name] already exists.
  Future<Profile> create({
    required String name,
    required String userDirectory,
    String? gamesDirectory,
    bool isBuiltIn = false,
  }) async {
    if (await nameExists(name)) {
      throw DuplicateProfileNameException(name);
    }
    final row = await db
        .into(db.profiles)
        .insertReturning(
          ProfilesCompanion.insert(
            name: name,
            userDirectory: userDirectory,
            gamesDirectory: Value(gamesDirectory),
            isBuiltIn: Value(isBuiltIn),
          ),
        );
    return _fromRow(row);
  }

  /// Sets the folders of the profile [cuid].
  Future<void> updateDirectories(
    String cuid, {
    String? userDirectory,
    String? gamesDirectory,
  }) {
    return (db.update(
      db.profiles,
    )..where((tbl) => tbl.cuid.equals(cuid))).write(
      ProfilesCompanion(
        userDirectory: userDirectory == null
            ? const Value.absent()
            : Value(userDirectory),
        gamesDirectory: gamesDirectory == null
            ? const Value.absent()
            : Value(gamesDirectory),
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

  Profile _fromRow(ProfileRow row) {
    return Profile(
      cuid: row.cuid,
      name: row.name,
      userDirectory: row.userDirectory,
      gamesDirectory: row.gamesDirectory,
      isBuiltIn: row.isBuiltIn,
      createdAt: row.createdAt,
    );
  }
}
