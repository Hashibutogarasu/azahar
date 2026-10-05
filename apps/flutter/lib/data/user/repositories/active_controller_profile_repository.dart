import '../../repositories/loadable.dart';
import '../../repositories/selectable.dart';
import 'key_value_repository.dart';

/// Stores the cuid of the controller profile in use. It is only used through the
/// `ControllerSettingsRepository`, which makes sure the profile exists.
class ActiveControllerProfileRepository extends KeyValueRepository
    implements Loadable, Selectable<String> {
  ActiveControllerProfileRepository(super.db);

  final String _key = 'active_controller_profile';

  String? _profileId;

  String? get profileId => _profileId;

  @override
  Future<void> load() async {
    _profileId = await read(_key);
  }

  @override
  Future<void> select(String key) async {
    await write(_key, key);
    _profileId = key;
  }
}
