import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';

final shareLogProvider = Provider<ShareLogService>((ref) => ShareLogService());

class ShareLogService {
  Future<bool> share() => AppServices.nativeBridge.shareLog();
}
