import 'key_value_repository.dart';
import '../../repositories/loadable.dart';

class LegacySettingsUiRepository extends KeyValueRepository
    implements Loadable {
  LegacySettingsUiRepository(super.db);

  final String _key = 'use_legacy_settings_ui';

  bool _useLegacySettingsUI = false;

  bool get useLegacySettingsUI => _useLegacySettingsUI;

  @override
  Future<void> load() async {
    _useLegacySettingsUI = await readBool(_key);
  }

  Future<void> setUseLegacySettingsUI(bool value) async {
    await writeBool(_key, value);
    _useLegacySettingsUI = value;
  }
}
