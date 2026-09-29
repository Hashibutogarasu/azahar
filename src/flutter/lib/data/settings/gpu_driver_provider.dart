import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../app_services.dart';

final gpuDriverProvider = Provider<GpuDriverService>(
  (ref) => GpuDriverService(),
);

class GpuDriverService {
  Future<bool> isSupported() =>
      AppServices.nativeBridge.supportsCustomDriverLoading();

  Future<List<GpuDriverInfo>> listDrivers() =>
      AppServices.nativeBridge.listGpuDrivers();

  Future<String?> selectedDriverName() =>
      AppServices.nativeBridge.getSelectedGpuDriver();

  Future<bool> installDriver(String path) =>
      AppServices.nativeBridge.installGpuDriver(path);

  Future<bool> selectDriver(String? uri) =>
      AppServices.nativeBridge.selectGpuDriver(uri);
}
