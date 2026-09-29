import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';

final articBaseProvider = Provider<ArticBaseService>(
  (ref) => ArticBaseService(),
);

class ArticBaseService {
  Future<String?> previousAddress() =>
      AppServices.articBaseAddressRepository.articBaseAddress();

  Future<void> connect(String address) async {
    await AppServices.articBaseAddressRepository.setArticBaseAddress(address);
    await AppServices.nativeBridge.launchEmulationActivity(
      'articbase://$address',
    );
  }
}
