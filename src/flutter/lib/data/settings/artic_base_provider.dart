import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';

final articBaseProvider = Provider<ArticBaseService>((ref) => ArticBaseService());

class ArticBaseService {
  Future<String?> previousAddress() => AppServices.settingsRepository.articBaseAddress();

  Future<void> connect(String address) async {
    await AppServices.settingsRepository.setArticBaseAddress(address);
    await AppServices.nativeBridge.launchEmulationActivity('articbase://$address');
  }
}
