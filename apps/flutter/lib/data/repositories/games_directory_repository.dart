import 'key_value_repository.dart';

class GamesDirectoryRepository extends KeyValueRepository {
  GamesDirectoryRepository(super.db);

  final String _key = 'game_path';

  Future<String?> gamesDirectoryUri() => read(_key);

  Future<void> setGamesDirectoryUri(String uri) => write(_key, uri);
}
