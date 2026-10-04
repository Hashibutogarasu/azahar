import 'master_key_value_repository.dart';

/// Whether the user already answered whether to move the legacy core data into a profile.
class LegacyUserDirectoryRepository extends MasterKeyValueRepository {
  LegacyUserDirectoryRepository(super.db);

  static const key = 'legacy_user_directory_decided';

  Future<bool> isDecided() => readBool(key);

  Future<void> setDecided() => writeBool(key, true);
}
