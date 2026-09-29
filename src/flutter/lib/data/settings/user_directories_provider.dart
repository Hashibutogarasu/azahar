import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../models/copy_dir_progress.dart';
import '../user_directory_bootstrap.dart';

final userDirectoriesProvider = Provider<UserDirectoriesService>(
  (ref) => UserDirectoriesService(),
);

class UserDirectoriesService {
  Future<String?> previousUserDirectory() =>
      AppServices.citraDirectoryRepository.citraDirectoryUri();

  Future<String?> pickUserDirectory() => FilePicker.getDirectoryPath();

  Stream<CopyDirProgress> copyDirProgress() =>
      AppServices.nativeBridge.copyDirProgress();

  Future<void> confirmUserDirectory({
    required String uri,
    String? previousUri,
    required bool moveData,
  }) async {
    if (Platform.isLinux) {
      await UserDirectoryBootstrap.writeConfiguredDirectory(uri);
    } else {
      await AppServices.nativeBridge.confirmUserDirectory(
        uri: uri,
        previousUri: previousUri,
        moveData: moveData,
      );
    }
    await AppServices.citraDirectoryRepository.setCitraDirectoryUri(uri);
    await AppServices.loggingService.userDirectoryChanged();
  }

  Future<String?> pickGamesDirectory() => FilePicker.getDirectoryPath();

  Future<void> confirmGamesDirectory(String uri) {
    return AppServices.gamesDirectoryRepository.setGamesDirectoryUri(uri);
  }
}
