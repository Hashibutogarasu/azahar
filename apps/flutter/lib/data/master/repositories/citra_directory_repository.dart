import 'master_key_value_repository.dart';
import 'profile_repository.dart';

/// The user folder of the default profile. Before any profile is the default, such as during the
/// setup wizard, it is the folder last chosen by the user.
class CitraDirectoryRepository extends MasterKeyValueRepository {
  CitraDirectoryRepository(super.db, this._profiles);

  final ProfileRepository _profiles;

  static const key = 'citra_directory';

  String get _key => key;

  Future<String?> citraDirectoryUri() async {
    final profile = await _profiles.defaultProfile();
    return profile?.userDirectory ?? await read(_key);
  }

  /// The folder last chosen by the user, whichever profile is the default.
  Future<String?> chosenDirectoryUri() => read(_key);

  Future<void> setCitraDirectoryUri(String uri) async {
    await write(_key, uri);
    final profile = await _profiles.defaultProfile();
    if (profile != null) {
      await _profiles.updateDirectories(profile.cuid, userDirectory: uri);
    }
  }
}
