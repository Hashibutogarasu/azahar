import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/settings_repository.dart';
import '../../models/copy_dir_progress.dart';
import '../../native/native_bridge.dart';

class SetupWizardViewModel extends ChangeNotifier {
  SetupWizardViewModel(this._nativeBridge, this._settingsRepository);

  final NativeBridge _nativeBridge;
  final SettingsRepository _settingsRepository;

  bool isLoaded = false;
  bool notificationsCompleted = false;
  bool microphoneCompleted = false;
  bool cameraCompleted = false;
  bool userDirectoryCompleted = false;
  bool gamesDirectoryCompleted = false;

  Future<void> refreshCompletionState() async {
    notificationsCompleted = (await Permission.notification.status).isGranted;
    microphoneCompleted = (await Permission.microphone.status).isGranted;
    cameraCompleted = (await Permission.camera.status).isGranted;
    userDirectoryCompleted = await _nativeBridge.hasUserDirectoryWriteAccess();
    final gamesUri = await _settingsRepository.gamesDirectoryUri();
    gamesDirectoryCompleted = gamesUri != null && gamesUri.isNotEmpty;
    isLoaded = true;
    notifyListeners();
  }

  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    notificationsCompleted = status.isGranted;
    notifyListeners();
    return notificationsCompleted;
  }

  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    microphoneCompleted = status.isGranted;
    notifyListeners();
    return microphoneCompleted;
  }

  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    cameraCompleted = status.isGranted;
    notifyListeners();
    return cameraCompleted;
  }

  Future<String?> previousUserDirectory() => _settingsRepository.citraDirectoryUri();

  Future<String?> pickUserDirectory() => _nativeBridge.openUserDirectory();

  Stream<CopyDirProgress> copyDirProgress() => _nativeBridge.copyDirProgress();

  Future<bool> confirmUserDirectory({
    required String uri,
    String? previousUri,
    required bool moveData,
  }) async {
    await _nativeBridge.confirmUserDirectory(
      uri: uri,
      previousUri: previousUri,
      moveData: moveData,
    );
    await _settingsRepository.setCitraDirectoryUri(uri);
    userDirectoryCompleted = await _nativeBridge.hasUserDirectoryWriteAccess();
    notifyListeners();
    return userDirectoryCompleted;
  }

  Future<String?> pickGamesDirectory() => _nativeBridge.openGamesDirectory();

  Future<bool> confirmGamesDirectory(String uri) async {
    await _settingsRepository.setGamesDirectoryUri(uri);
    gamesDirectoryCompleted = true;
    notifyListeners();
    return true;
  }

  Future<void> completeSetup() {
    return _settingsRepository.setFirstApplicationLaunchComplete();
  }
}
