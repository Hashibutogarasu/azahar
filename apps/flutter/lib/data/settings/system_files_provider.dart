import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';

final systemFilesProvider = Provider<SystemFilesService>(
  (ref) => SystemFilesService(),
);

class SystemFilesService {
  Future<bool> isFullConsoleLinked() =>
      AppServices.nativeBridge.isFullConsoleLinked();

  Future<List<bool>> areSystemTitlesInstalled() {
    return AppServices.nativeBridge.areSystemTitlesInstalled();
  }

  Future<void> installSystemFiles(bool old3ds) {
    return AppServices.nativeBridge.installSystemFiles(old3ds);
  }

  Future<void> unlinkConsole() => AppServices.nativeBridge.unlinkConsole();

  Future<String> getHomeMenuPath(int region) =>
      AppServices.nativeBridge.getHomeMenuPath(region);

  Future<bool> isSystemSetupNeeded() =>
      AppServices.nativeBridge.isSystemSetupNeeded();

  Future<void> setSystemSetupNeeded(bool needed) {
    return AppServices.nativeBridge.setSystemSetupNeeded(needed);
  }

  /// Returns the path that starts the system files installation from the Artic Base server at
  /// [address].
  String articInstallPath({required String address, required bool installO3ds}) {
    final scheme = installO3ds ? 'articinio' : 'articinin';
    return '$scheme://$address';
  }
}
