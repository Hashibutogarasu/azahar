import 'dart:io';

import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../logging_service.dart';
import '../repositories/citra_directory_repository.dart';
import '../repositories/first_launch_repository.dart';
import '../repositories/games_directory_repository.dart';
import '../repositories/profile_repository.dart';
import '../settings/system_save_repository.dart';
import '../user_directory_bootstrap.dart';
import 'profile.dart';

/// Creates the profiles and switches the emulator between them.
///
/// The built-in profile and the user profiles only differ in when they are created and where
/// their folder is. The built-in profile is created at startup in the app's documents, and a user
/// profile uses folders the user picked. Both reach the core the same way: on Android by the tree
/// URI of the profiles document provider, which the native side resolves to the folder itself, and
/// on Linux by the path of their folder.
class ProfileService {
  ProfileService(
    this._profiles,
    this._nativeBridge,
    this._citraDirectories,
    this._gamesDirectories,
    this._firstLaunch,
    this._systemSave,
    this._logging,
  );

  final ProfileRepository _profiles;
  final NativeBridge _nativeBridge;
  final CitraDirectoryRepository _citraDirectories;
  final GamesDirectoryRepository _gamesDirectories;
  final FirstLaunchRepository _firstLaunch;
  final SystemSaveRepository _systemSave;
  final LoggingService _logging;

  static const String builtInName = 'builtin';
  static const String _defaultUserName = 'AZAHAR';

  /// Prepares the profiles at startup: creates the built-in profile, moves an existing setup into
  /// a user profile, and applies the default profile to the core.
  Future<void> initialize() async {
    await ensureBuiltInProfile();
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

  /// Creates the built-in profile in the app's documents if it does not exist yet.
  Future<Profile> ensureBuiltInProfile() async {
    final existing = await _profiles.builtInProfile();
    if (existing != null) return existing;

    final created = await _profiles.create(
      name: builtInName,
      userDirectory: '',
      isBuiltIn: true,
    );
    final documents = await getApplicationDocumentsDirectory();
    final folder = Directory(p.join(documents.path, 'profiles', created.hash));
    await folder.create(recursive: true);
    final location = Uri.directory(folder.path).toString();
    await _profiles.updateDirectories(created.cuid, userDirectory: location);
    final profile = (await _profiles.profileByCuid(created.cuid))!;
    await _initializeFolder(profile);
    return profile;
  }

  /// Creates a user profile from the folders chosen so far, without moving any data, and makes it
  /// the default profile. Its name is the user name of the emulated console.
  Future<Profile> createUserProfileFromCurrent() async {
    final userDirectory = await _citraDirectories.chosenDirectoryUri();
    final gamesDirectory = await _gamesDirectories.chosenDirectoryUri();
    await _systemSave.load();
    final userName = _systemSave.username.trim();
    final profile = await _profiles.create(
      name: await _uniqueName(userName.isEmpty ? _defaultUserName : userName),
      userDirectory: _location(userDirectory!),
      gamesDirectory: gamesDirectory,
    );
    await switchTo(profile.cuid);
    return profile;
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
    final profile = await _profiles.create(
      name: name,
      userDirectory: _location(userDirectory),
      gamesDirectory: gamesDirectory,
    );
    await _initializeFolder(profile);
    return profile;
  }

  /// Makes the profile [cuid] the default one and points the core at its folder.
  Future<void> switchTo(String cuid) async {
    final profile = await _profiles.profileByCuid(cuid);
    if (profile == null) return;
    await _profiles.setDefaultProfileCuid(cuid);
    await _publishProfiles();
    await _apply(profile);
    await _systemSave.load();
    await _logging.userDirectoryChanged();
  }

  /// Points the core at the folder of the default profile again, after its folder changed.
  Future<void> reapplyDefaultProfile() async {
    final profile = await _profiles.defaultProfile();
    if (profile != null) {
      await switchTo(profile.cuid);
    }
  }

  /// Where the folder of [profile] is, for showing it to the user.
  String displayLocation(Profile profile) {
    final uri = Uri.parse(profile.userDirectory);
    if (uri.scheme == 'file') return uri.toFilePath();
    return Uri.decodeComponent(
      uri.pathSegments.isEmpty ? '' : uri.pathSegments.last,
    );
  }

  Future<bool> _needsMigration() async {
    if (await _firstLaunch.isFirstApplicationLaunch()) return false;
    final profiles = await _profiles.profiles();
    if (profiles.any((profile) => !profile.isBuiltIn)) return false;
    return await _citraDirectories.chosenDirectoryUri() != null;
  }

  Future<void> _apply(Profile profile) async {
    final directory = await _coreDirectory(profile);
    if (Platform.isLinux &&
        await UserDirectoryBootstrap.readConfiguredDirectory() == null) {
      await UserDirectoryBootstrap.writeConfiguredDirectory(directory);
    }
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
    return Uri.parse(profile.userDirectory).toFilePath();
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

  /// A user folder as stored in a profile: a URI, with Linux paths turned into file URIs. The
  /// games folder is stored as picked, since the games scan takes it as is.
  String _location(String folder) {
    if (folder.contains('://')) return folder;
    return Uri.directory(folder).toString();
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
