import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import '../../native/native_bridge.dart';
import 'linux_permission_repository.dart';

/// Runtime permission kinds.
enum AppPermission { notification, microphone, camera }

/// Checks and requests runtime permissions via `permission_handler`.
///
/// Unsupported platforms override this, see [LinuxPermissionRepository].
class PermissionRepository {
  PermissionRepository();

  /// Picks the implementation for the current platform.
  factory PermissionRepository.forPlatform(NativeBridge nativeBridge) {
    if (Platform.isLinux) {
      return LinuxPermissionRepository(nativeBridge);
    }
    return PermissionRepository();
  }

  Future<bool> isGranted(AppPermission permission) async {
    final status = await _toPermission(permission).status;
    return status.isGranted;
  }

  Future<bool> request(AppPermission permission) async {
    final status = await _toPermission(permission).request();
    return status.isGranted;
  }

  Permission _toPermission(AppPermission permission) {
    switch (permission) {
      case AppPermission.notification:
        return Permission.notification;
      case AppPermission.microphone:
        return Permission.microphone;
      case AppPermission.camera:
        return Permission.camera;
    }
  }
}
