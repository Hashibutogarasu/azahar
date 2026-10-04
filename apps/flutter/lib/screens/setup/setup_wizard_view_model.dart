import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../data/profiles/profile_service.dart';
import '../../data/master/repositories/first_launch_repository.dart';
import '../../data/master/repositories/games_directory_repository.dart';
import '../../data/repositories/permission_repository.dart';
import '../../data/settings/user_directories_provider.dart';

class SetupWizardViewModel extends ChangeNotifier {
  SetupWizardViewModel(
    this._nativeBridge,
    this._firstLaunchRepository,
    this._gamesDirectoryRepository,
    this._userDirectories,
    this._permissionRepository,
    this._profileService,
  );

  final NativeBridge _nativeBridge;
  final PermissionRepository _permissionRepository;
  final FirstLaunchRepository _firstLaunchRepository;
  final GamesDirectoryRepository _gamesDirectoryRepository;
  final UserDirectoriesService _userDirectories;
  final ProfileService _profileService;

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
    userDirectoryCompleted = await _isUserDirectoryConfigured();
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
    cameraCompleted = await _permissionRepository.request(AppPermission.camera);
    notifyListeners();
    return cameraCompleted;
  }

  Future<String?> previousUserDirectory() =>
      _userDirectories.previousUserDirectory();

  Future<String?> pickUserDirectory() => _userDirectories.pickUserDirectory();

  Stream<CopyDirProgress> copyDirProgress() =>
      _userDirectories.copyDirProgress();

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
    userDirectoryCompleted = await _isUserDirectoryConfigured();
    notifyListeners();
    return userDirectoryCompleted;
  }

  Future<bool> _isUserDirectoryConfigured() async {
    if (Platform.isLinux) {
      return await _userDirectories.chosenUserDirectory() != null;
    }
    return _nativeBridge.hasUserDirectoryWriteAccess();
  }

  Future<String?> pickGamesDirectory() => _userDirectories.pickGamesDirectory();

  Future<bool> confirmGamesDirectory(String uri) async {
    await _userDirectories.confirmGamesDirectory(uri);
    gamesDirectoryCompleted = true;
    notifyListeners();
    return true;
  }

  bool get foldersConfirmed =>
      userDirectoryCompleted && gamesDirectoryCompleted;

  Future<void> completeSetup() async {
    if (foldersConfirmed) {
      await _profileService.createUserProfileFromCurrent();
    } else {
      final builtIn = await _profileService.ensureBuiltInProfile();
      await _profileService.switchTo(builtIn.cuid);
    }
    await _firstLaunchRepository.setFirstApplicationLaunchComplete();
  }
}
