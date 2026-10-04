import 'master_key_value_repository.dart';

/// App-wide values without a repository of their own.
class MasterSettingsRepository extends MasterKeyValueRepository {
  MasterSettingsRepository(super.db);

  static const _pendingUserDatabaseKey = 'pending_user_database';

  /// A user database carried over from an earlier version that no profile owns yet.
  Future<String?> pendingUserDatabase() => read(_pendingUserDatabaseKey);

  Future<void> setPendingUserDatabase(String path) =>
      write(_pendingUserDatabaseKey, path);

  Future<void> clearPendingUserDatabase() => deleteKey(_pendingUserDatabaseKey);
}
