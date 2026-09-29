import 'key_value_repository.dart';

class ArticBaseAddressRepository extends KeyValueRepository {
  ArticBaseAddressRepository(super.db);

  final String _key = 'last_artic_base_addr';

  Future<String?> articBaseAddress() => read(_key);

  Future<void> setArticBaseAddress(String address) => write(_key, address);
}
