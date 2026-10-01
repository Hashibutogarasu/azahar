import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';

final articBaseProvider = Provider<ArticBaseService>(
  (ref) => ArticBaseService(),
);

class ArticBaseService {
  Future<String?> previousAddress() =>
      AppServices.articBaseAddressRepository.articBaseAddress();

  /// Remembers [address] and returns the path that starts the connection to it.
  Future<String> connectionPath(String address) async {
    await AppServices.articBaseAddressRepository.setArticBaseAddress(address);
    return 'articbase://$address';
  }
}
