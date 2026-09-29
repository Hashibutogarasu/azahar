import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.freezed.dart';

abstract final class GameExtensions {
  static const Set<String> extensions = {
    '3dsx',
    'elf',
    'axf',
    'cci',
    'cxi',
    'app',
  };
  static const Set<String> badExtensions = {
    'rar',
    'zip',
    '7z',
    'torrent',
    'tar',
    'gz',
  };
  static const Set<String> allExtensions = {...extensions, ...badExtensions};
}

@freezed
abstract class Game with _$Game {
  const factory Game({
    required String title,
    required String description,
    required String path,
    required int titleId,
    required String company,
    required String regions,
    required bool isInstalled,
    required bool isSystemTitle,
    required bool isVisibleSystemTitle,
    required String filename,
    String? iconPath,
  }) = _Game;
}
