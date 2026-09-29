import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../models/gpu_driver_info.dart';

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
