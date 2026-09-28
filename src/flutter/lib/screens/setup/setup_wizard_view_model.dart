import 'package:flutter/foundation.dart';

import '../../data/repositories/first_launch_repository.dart';
import '../../data/repositories/game_repository.dart';
import '../../data/repositories/games_directory_repository.dart';
import '../../data/repositories/permission_repository.dart';
import '../../data/settings/user_directories_provider.dart';
import '../../models/copy_dir_progress.dart';
import '../../native/native_bridge.dart';

class SetupWizardViewModel extends ChangeNotifier {
  SetupWizardViewModel(
    this._nativeBridge,
    this._firstLaunchRepository,
    this._gamesDirectoryRepository,
    this._userDirectories,
    this._gameRepository,
    this._permissionRepository,
  );

  final NativeBridge _nativeBridge;
  final PermissionRepository _permissionRepository;
  final FirstLaunchRepository _firstLaunchRepository;
  final GamesDirectoryRepository _gamesDirectoryRepository;
  final UserDirectoriesService _userDirectories;
  final GameRepository _gameRepository;

  bool isLoaded = false;
  bool notificationsCompleted = false;
  bool microphoneCompleted = false;
  bool cameraCompleted = false;
  bool userDirectoryCompleted = false;
  bool gamesDirectoryCompleted = false;

  Future<void> refreshCompletionState() async {
    notificationsCompleted = await _permissionRepository.isGranted(
      AppPermission.notification,
    );
    microphoneCompleted = await _permissionRepository.isGranted(
      AppPermission.microphone,
    );
    cameraCompleted = await _permissionRepository.isGranted(
      AppPermission.camera,
    );
    userDirectoryCompleted = await _nativeBridge.hasUserDirectoryWriteAccess();
    final gamesUri = await _gamesDirectoryRepository.gamesDirectoryUri();
    gamesDirectoryCompleted = gamesUri != null && gamesUri.isNotEmpty;
    isLoaded = true;
    notifyListeners();
  }

  Future<bool> requestNotificationPermission() async {
    notificationsCompleted = await _permissionRepository.request(
      AppPermission.notification,
    );
    notifyListeners();
    return notificationsCompleted;
  }

  Future<bool> requestMicrophonePermission() async {
    microphoneCompleted = await _permissionRepository.request(
      AppPermission.microphone,
    );
    notifyListeners();
    return microphoneCompleted;
  }

  Future<bool> requestCameraPermission() async {
    cameraCompleted = await _permissionRepository.request(
      AppPermission.camera,
    );
    notifyListeners();
    return cameraCompleted;
  }

  Future<String?> previousUserDirectory() => _userDirectories.previousUserDirectory();

  Future<String?> pickUserDirectory() => _userDirectories.pickUserDirectory();

  Stream<CopyDirProgress> copyDirProgress() => _userDirectories.copyDirProgress();

  Future<bool> confirmUserDirectory({
    required String uri,
    String? previousUri,
    required bool moveData,
  }) async {
    await _userDirectories.confirmUserDirectory(
      uri: uri,
      previousUri: previousUri,
      moveData: moveData,
    );
    userDirectoryCompleted = await _nativeBridge.hasUserDirectoryWriteAccess();
    notifyListeners();
    return userDirectoryCompleted;
  }

  Future<String?> pickGamesDirectory() => _userDirectories.pickGamesDirectory();

  Future<bool> confirmGamesDirectory(String uri) async {
    await _userDirectories.confirmGamesDirectory(uri);
    gamesDirectoryCompleted = true;
    notifyListeners();
    return true;
  }

  Future<void> completeSetup() async {
    await _firstLaunchRepository.setFirstApplicationLaunchComplete();
    await _gameRepository.rescan();
  }
}
