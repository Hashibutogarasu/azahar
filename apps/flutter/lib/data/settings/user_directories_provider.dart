import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../app_services.dart';

final userDirectoriesProvider = Provider<UserDirectoriesService>(
  (ref) => UserDirectoriesService(),
);

class UserDirectoriesService {
  Future<String?> previousUserDirectory() =>
      AppServices.citraDirectoryRepository.citraDirectoryUri();

  /// The user folder last chosen by the user, or null when none was chosen yet.
  Future<String?> chosenUserDirectory() =>
      AppServices.citraDirectoryRepository.chosenDirectoryUri();

  Future<String?> pickUserDirectory() => Platform.isAndroid
      ? AppServices.nativeBridge.openUserDirectory()
      : FilePicker.getDirectoryPath();

  Stream<CopyDirProgress> copyDirProgress() =>
      AppServices.nativeBridge.copyDirProgress();

  Future<void> confirmUserDirectory({
    required String uri,
    String? previousUri,
    required bool moveData,
  }) async {
    await AppServices.nativeBridge.confirmUserDirectory(
      uri: uri,
      previousUri: previousUri,
      moveData: moveData,
    );
    await AppServices.citraDirectoryRepository.setCitraDirectoryUri(uri);
    await AppServices.loggingService.userDirectoryChanged();
    await AppServices.profileService.reapplyDefaultProfile();
  }

  Future<String?> pickGamesDirectory() => Platform.isAndroid
      ? AppServices.nativeBridge.openGamesDirectory()
      : FilePicker.getDirectoryPath();

  Future<void> confirmGamesDirectory(String uri) {
    return AppServices.gamesDirectoryRepository.setGamesDirectoryUri(uri);
  }
}
