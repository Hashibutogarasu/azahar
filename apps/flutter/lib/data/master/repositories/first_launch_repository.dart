import 'master_key_value_repository.dart';

class FirstLaunchRepository extends MasterKeyValueRepository {
  FirstLaunchRepository(super.db);

  static const key = 'first_application_launch';

  Future<bool> isFirstApplicationLaunch() => readBool(key, defaultValue: true);

  Future<void> setFirstApplicationLaunchComplete() => writeBool(key, false);
}
