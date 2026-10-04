import 'dart:io';

import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:path/path.dart' as p;

import '../file_moves.dart';
import '../folder_location.dart';
import '../logging_service.dart';
import '../master/legacy_user_directory_migration.dart';
import '../master/repositories/citra_directory_repository.dart';
import '../master/repositories/first_launch_repository.dart';
import '../master/repositories/games_directory_repository.dart';
import '../master/repositories/legacy_user_directory_repository.dart';
import '../master/repositories/locations_repository.dart';
import '../master/repositories/master_settings_repository.dart';
import '../master/repositories/profile_repository.dart';
import '../settings/system_save_repository.dart';
import '../user/user_database.dart';
import '../user/user_sessions.dart';
import 'profile.dart';

/// Creates the profiles and switches the emulator between them.
///
/// The built-in profile and the user profiles only differ in when they are created and where
/// their folder is. The built-in profile is created at startup in the profiles folder of the app,
/// and a user profile uses folders the user picked. Every profile has its own user database in
/// the profiles folder, which is opened when the profile becomes the active one. Both reach the
/// core the same way: on Android by the tree URI of the profiles document provider, which the
/// native side resolves to the folder itself, and on Linux by the path of their folder.
class ProfileService {
  ProfileService(
    this._profiles,
    this._locations,
    this._settings,
    this._sessions,
    this._nativeBridge,
    this._citraDirectories,
    this._gamesDirectories,
    this._firstLaunch,
    this._systemSave,
    this._logging,
    this._legacyDecision,
  );

  final ProfileRepository _profiles;
  final LocationsRepository _locations;
  final MasterSettingsRepository _settings;
  final UserSessions _sessions;
  final NativeBridge _nativeBridge;
  final CitraDirectoryRepository _citraDirectories;
  final GamesDirectoryRepository _gamesDirectories;
  final FirstLaunchRepository _firstLaunch;
  final SystemSaveRepository _systemSave;
  final LoggingService _logging;
  final LegacyUserDirectoryRepository _legacyDecision;

  static const String builtInName = 'builtin';
  static const String _defaultUserName = 'AZAHAR';

  /// Prepares the profiles at startup: creates the built-in profile, opens the user database of
  /// the active profile, moves an existing setup into a user profile, and applies the default
  /// profile to the core.
  ///
  /// [migrateLegacyData] is the user's answer to [shouldAskLegacyMigration], or null when not
  /// asked.
  Future<void> initialize({bool? migrateLegacyData}) async {
    final builtIn = await ensureBuiltInProfile();
    final migration = await _legacyMigration();
    if (migrateLegacyData == true || await migration.isInterrupted()) {
      await migration.migrate(FolderLocation.toPath(builtIn.userDirectory)!);
      await _nativeBridge.initializeStorage(builtIn.userDirectory);
    }
    if (migrateLegacyData != null) {
      await _legacyDecision.setDecided();
    }
    await _sessions.open((await _profiles.activeProfile())!);
    if (await _needsMigration()) {
      await createUserProfileFromCurrent();
      return;
    }
    await _publishProfiles();
    final profile = await _profiles.defaultProfile();
    if (profile != null && Platform.isLinux) {
      await _apply(profile);
    }
  }

  /// Whether to ask before [initialize] if the core data left in the app data folder should move
  /// into the built-in profile.
  Future<bool> shouldAskLegacyMigration() async {
    if (!Platform.isLinux) return false;
    final migration = await _legacyMigration();
    if (await migration.isInterrupted()) return false;
    if (await _legacyDecision.isDecided()) return false;
    if (await _usesSystemDirectory()) return false;
    return migration.hasLegacyData();
  }

  /// Creates the built-in profile if it does not exist yet, and moves it into the profiles folder
  /// when an earlier version created it elsewhere.
  Future<Profile> ensureBuiltInProfile() async {
    final existing = await _profiles.builtInProfile();
    if (existing != null) return _relocateBuiltIn(existing);

    final created = await _profiles.create(
      name: builtInName,
      userDirectory: '',
      isBuiltIn: true,
    );
    final folder = await _profileFolder(created);
    await folder.create(recursive: true);
    final database = File(p.join(folder.path, UserDatabase.fileName));
    await _adoptPendingDatabase(database);
    await _profiles.updateDirectories(
      created.cuid,
      userDirectory: FolderLocation.toUri(folder.path),
      databaseFile: database.path,
    );
    final profile = (await _profiles.profileByCuid(created.cuid))!;
    await _initializeFolder(profile);
    return profile;
  }

  /// Creates a user profile from the folders chosen so far, without moving any data, and makes it
  /// the default profile. Its name is the user name of the emulated console, and its user
  /// database starts as a copy of the active one.
  Future<Profile> createUserProfileFromCurrent() async {
    final userDirectory = await _citraDirectories.chosenDirectoryUri();
    final gamesDirectory = await _gamesDirectories.chosenDirectoryUri();
    await _systemSave.load();
    final userName = _systemSave.username.trim();
    final created = await _profiles.create(
      name: await _uniqueName(userName.isEmpty ? _defaultUserName : userName),
      userDirectory: FolderLocation.toUri(userDirectory!),
      gamesDirectory: gamesDirectory,
    );
    final database = await _databaseFile(created);
    await _sessions.copyCurrentTo(database);
    await _profiles.updateDirectories(
      created.cuid,
      databaseFile: database.path,
    );
    await switchTo(created.cuid);
    return (await _profiles.profileByCuid(created.cuid))!;
  }

  /// Creates a user profile named [name] in the folders the user picked, and creates the folders
  /// the core expects in its user folder.
  ///
  /// Throws [DuplicateProfileNameException] when a profile named [name] already exists.
  Future<Profile> createUserProfile({
    required String name,
    required String userDirectory,
    required String gamesDirectory,
  }) async {
    final created = await _profiles.create(
      name: name,
      userDirectory: FolderLocation.toUri(userDirectory),
      gamesDirectory: gamesDirectory,
    );
    await _profiles.updateDirectories(
      created.cuid,
      databaseFile: (await _databaseFile(created)).path,
    );
    final profile = (await _profiles.profileByCuid(created.cuid))!;
    await _initializeFolder(profile);
    return profile;
  }

  /// Makes the profile [cuid] the default one, opens its user database and points the core at
  /// its folder.
  Future<void> switchTo(String cuid) async {
    final profile = await _profiles.profileByCuid(cuid);
    if (profile == null) return;
    await _profiles.setDefaultProfileCuid(cuid);
    await _publishProfiles();
    await _sessions.open(profile);
    await _apply(profile);
    await _systemSave.load();
    await _logging.userDirectoryChanged();
  }

  /// Removes the user profile [cuid] and its user database without touching the files in its
  /// folder, since the folder was picked by the user. When it was the default profile, the
  /// built-in profile takes its place. The folders the core expects are then created again in the
  /// folder now in use, so the core never starts on a folder it cannot write to.
  ///
  /// Returns whether the default profile changed. The built-in profile cannot be removed.
  Future<bool> deleteProfile(String cuid) async {
    final profile = await _profiles.profileByCuid(cuid);
    if (profile == null || profile.isBuiltIn) return false;
    final wasDefault = await _profiles.defaultProfileCuid() == cuid;
    await _profiles.delete(cuid);
    await _publishProfiles();
    final current = wasDefault
        ? await ensureBuiltInProfile()
        : await _profiles.defaultProfile();
    if (current != null) {
      await _nativeBridge.initializeStorage(current.userDirectory);
      if (wasDefault) {
        await switchTo(current.cuid);
      }
    }
    await _sessions.deleteWhenClosed(profile);
    return wasDefault;
  }

  /// Points the core at the folder of the default profile again, after its folder changed.
  Future<void> reapplyDefaultProfile() async {
    final profile = await _profiles.defaultProfile();
    if (profile != null) {
      await switchTo(profile.cuid);
    }
  }

  /// Where the folder of [profile] is, for showing it to the user.
  String displayLocation(Profile profile) =>
      FolderLocation.display(profile.userDirectory);

  Future<bool> _needsMigration() async {
    if (await _firstLaunch.isFirstApplicationLaunch()) return false;
    final profiles = await _profiles.profiles();
    if (profiles.any((profile) => !profile.isBuiltIn)) return false;
    return await _citraDirectories.chosenDirectoryUri() != null;
  }

  Future<LegacyUserDirectoryMigration> _legacyMigration() async {
    return LegacyUserDirectoryMigration(await _locations.systemDirectory());
  }

  Future<Directory> _profileFolder(Profile profile) async {
    final profiles = await _locations.profilesDirectory();
    return Directory(p.join(profiles.path, profile.hash));
  }

  Future<File> _databaseFile(Profile profile) async {
    return File(
      p.join((await _profileFolder(profile)).path, UserDatabase.fileName),
    );
  }

  /// Gives [database] the user database carried over from an earlier version without a profile.
  Future<void> _adoptPendingDatabase(File database) async {
    final pending = await _settings.pendingUserDatabase();
    if (pending == null) return;
    final file = File(pending);
    if (await file.exists()) {
      await FileMoves.move(file, database.path);
    }
    await _settings.clearPendingUserDatabase();
  }

  /// Moves the built-in profile folder into the profiles folder, together with its user database.
  Future<Profile> _relocateBuiltIn(Profile builtIn) async {
    final current = FolderLocation.toPath(builtIn.userDirectory);
    final target = await _profileFolder(builtIn);
    final database = File(p.join(target.path, UserDatabase.fileName));
    if (current == null || p.equals(current, target.path)) {
      if (builtIn.databaseFile.isNotEmpty) return builtIn;
      await _profiles.updateDirectories(
        builtIn.cuid,
        databaseFile: database.path,
      );
      return (await _profiles.profileByCuid(builtIn.cuid))!;
    }

    final folder = Directory(current);
    if (await folder.exists()) {
      await target.create(recursive: true);
      for (final entry in await folder.list(followLinks: false).toList()) {
        await FileMoves.move(entry, p.join(target.path, p.basename(entry.path)));
      }
      await _deleteIfEmpty(folder);
      await _deleteIfEmpty(folder.parent);
    }
    await _profiles.updateDirectories(
      builtIn.cuid,
      userDirectory: FolderLocation.toUri(target.path),
      databaseFile: database.path,
    );
    final relocated = (await _profiles.profileByCuid(builtIn.cuid))!;
    await _initializeFolder(relocated);
    return relocated;
  }

  Future<void> _deleteIfEmpty(Directory directory) async {
    if (await directory.exists() && await directory.list().isEmpty) {
      await directory.delete();
    }
  }

  /// Whether a folder in use as a user folder is the system folder itself, whose core data must
  /// then stay where it is.
  Future<bool> _usesSystemDirectory() async {
    final system = (await _locations.systemDirectory()).path;
    final locations = [
      await _citraDirectories.chosenDirectoryUri(),
      for (final profile in await _profiles.profiles()) profile.userDirectory,
    ];
    return locations.any((location) {
      final path = location == null ? null : FolderLocation.toPath(location);
      return path != null && p.equals(path, system);
    });
  }

  Future<void> _apply(Profile profile) async {
    final directory = await _coreDirectory(profile);
    await _nativeBridge.confirmUserDirectory(uri: directory, moveData: false);
  }

  Future<void> _initializeFolder(Profile profile) async {
    await _publishProfiles();
    await _nativeBridge.initializeStorage(profile.userDirectory);
  }

  /// The folder of [profile] as the core reaches it.
  Future<String> _coreDirectory(Profile profile) async {
    if (Platform.isAndroid) {
      return _nativeBridge.profileTreeUri(profile.hash);
    }
    return FolderLocation.toPath(profile.userDirectory)!;
  }

  Future<void> _publishProfiles() async {
    if (!Platform.isAndroid) return;
    final profiles = await _profiles.profiles();
    await _nativeBridge.setProfiles([
      for (final profile in profiles)
        (
          hash: profile.hash,
          name: profile.name,
          isBuiltIn: profile.isBuiltIn,
          location: profile.userDirectory,
        ),
    ]);
  }

  Future<String> _uniqueName(String base) async {
    if (!await _profiles.nameExists(base)) return base;
    var index = 2;
    while (await _profiles.nameExists('$base ($index)')) {
      index++;
    }
    return '$base ($index)';
  }
}
