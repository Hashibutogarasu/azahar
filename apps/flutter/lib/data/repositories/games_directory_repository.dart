import 'key_value_repository.dart';
import 'profile_repository.dart';

/// The games folder of the default profile. Before any profile is the default, such as during the
/// setup wizard, it is the folder last chosen by the user.
class GamesDirectoryRepository extends KeyValueRepository {
  GamesDirectoryRepository(super.db, this._profiles);

  final ProfileRepository _profiles;

  final String _key = 'game_path';

  Future<String?> gamesDirectoryUri() async {
    final profile = await _profiles.defaultProfile();
    if (profile != null) return profile.gamesDirectory;
    return read(_key);
  }

  /// The folder last chosen by the user, whichever profile is the default.
  Future<String?> chosenDirectoryUri() => read(_key);

  Future<void> setGamesDirectoryUri(String uri) async {
    await write(_key, uri);
    final profile = await _profiles.defaultProfile();
    if (profile != null) {
      await _profiles.updateDirectories(profile.cuid, gamesDirectory: uri);
    }
  }
}
