import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../models/copy_dir_progress.dart';

final userDirectoriesProvider = Provider<UserDirectoriesService>(
  (ref) => UserDirectoriesService(),
);

class UserDirectoriesService {
  Future<String?> previousUserDirectory() =>
      AppServices.citraDirectoryRepository.citraDirectoryUri();

  Future<String?> pickUserDirectory() => AppServices.nativeBridge.openUserDirectory();

  Stream<CopyDirProgress> copyDirProgress() => AppServices.nativeBridge.copyDirProgress();

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
  }

  Future<String?> pickGamesDirectory() => AppServices.nativeBridge.openGamesDirectory();

  Future<void> confirmGamesDirectory(String uri) {
    return AppServices.gamesDirectoryRepository.setGamesDirectoryUri(uri);
  }
}
