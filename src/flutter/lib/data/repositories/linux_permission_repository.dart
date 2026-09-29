import '../../native/native_bridge.dart';
import 'permission_repository.dart';

/// Requests permissions natively via GTK, since `permission_handler` has no
/// Linux implementation.
class LinuxPermissionRepository extends PermissionRepository {
  LinuxPermissionRepository(this._nativeBridge);

  final NativeBridge _nativeBridge;

  @override
  Future<bool> isGranted(AppPermission permission) {
    return _nativeBridge.hasPermission(permission.name);
  }

  @override
  Future<bool> request(AppPermission permission) {
    return _nativeBridge.requestPermission(permission.name);
  }
}
