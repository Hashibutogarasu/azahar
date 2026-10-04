import 'key_value_repository.dart';
import '../../repositories/loadable.dart';

class LanguageCodeRepository extends KeyValueRepository implements Loadable {
  LanguageCodeRepository(super.db);

  final String _key = 'app_language';

  @override
  List<(String, String)> get keyMigrations => [('AppLanguage', _key)];

  String? _languageCode;

  String? get languageCode => _languageCode;

  @override
  Future<void> load() async {
    _languageCode = await read(_key);
  }

  Future<void> setLanguageCode(String? languageCode) async {
    if (languageCode == null) {
      await deleteKey(_key);
    } else {
      await write(_key, languageCode);
    }
    _languageCode = languageCode;
  }
}
