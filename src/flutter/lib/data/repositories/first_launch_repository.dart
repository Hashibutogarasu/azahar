import 'key_value_repository.dart';

class FirstLaunchRepository extends KeyValueRepository {
  FirstLaunchRepository(super.db);

  final String _key = 'first_application_launch';

  @override
  List<(String, String)> get keyMigrations => [
    ('FirstApplicationLaunch', _key),
  ];

  Future<bool> isFirstApplicationLaunch() => readBool(_key, defaultValue: true);

  Future<void> setFirstApplicationLaunchComplete() => writeBool(_key, false);
}
