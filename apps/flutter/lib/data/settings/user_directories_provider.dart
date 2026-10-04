import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../app_services.dart';
import '../../screens/games/games_provider.dart';

final userDirectoriesProvider = Provider<UserDirectoriesService>(
  (ref) => UserDirectoriesService(
    onGamesChanged: () => ref.read(gamesProvider.notifier).rescan(),
  ),
);

class UserDirectoriesService {
  UserDirectoriesService({this.onGamesChanged});

  /// Starts a new scan of the games, since both folders decide which games are listed. The
  /// setup wizard leaves it out, because the games list scans when it is first shown.
  final Future<void> Function()? onGamesChanged;

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
    _scanGames();
  }

  Future<String?> pickGamesDirectory() => Platform.isAndroid
      ? AppServices.nativeBridge.openGamesDirectory()
      : FilePicker.getDirectoryPath();

  Future<void> confirmGamesDirectory(String uri) async {
    await AppServices.gamesDirectoryRepository.setGamesDirectoryUri(uri);
    _scanGames();
  }

  /// Does not wait for the scan, so a folder can be confirmed without waiting for every game to
  /// be read.
  void _scanGames() {
    final scan = onGamesChanged;
    if (scan != null) unawaited(scan());
  }
}
