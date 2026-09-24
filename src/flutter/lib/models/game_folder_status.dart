import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_folder_status.freezed.dart';

/// Whether each of a game's well-known folders exists, mirroring the Open Folder / Uninstall
/// submenus of the Compose client's `GamesScreen.kt` (`OpenFolderMenuButton`, `UninstallMenuButton`).
@freezed
abstract class GameFolderStatus with _$GameFolderStatus {
  const factory GameFolderStatus({
    required bool app,
    required bool save,
    required bool updates,
    required bool dlc,
    required bool extra,
    required bool textures,
    required bool mods,
  }) = _GameFolderStatus;
}
