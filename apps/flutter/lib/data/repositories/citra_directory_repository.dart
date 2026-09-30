import 'key_value_repository.dart';

class CitraDirectoryRepository extends KeyValueRepository {
  CitraDirectoryRepository(super.db);

  final String _key = 'citra_directory';

  @override
  List<(String, String)> get keyMigrations => [('CITRA_DIRECTORY', _key)];

  Future<String?> citraDirectoryUri() => read(_key);

  Future<void> setCitraDirectoryUri(String uri) => write(_key, uri);
}
