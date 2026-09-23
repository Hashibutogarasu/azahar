import 'package:flutter/services.dart';

import '../models/copy_dir_progress.dart';
import '../models/game.dart';
import '../models/shader_cache_progress.dart';

class NativeBridge {
  NativeBridge()
      : _channel = const MethodChannel('org.citra.citra_emu/azahar_bridge'),
        _shaderProgressChannel =
            const EventChannel('org.citra.citra_emu/azahar_bridge/shader_progress'),
        _copyProgressChannel =
            const EventChannel('org.citra.citra_emu/azahar_bridge/copy_progress');

  final MethodChannel _channel;
  final EventChannel _shaderProgressChannel;
  final EventChannel _copyProgressChannel;

  Stream<CopyDirProgress> copyDirProgress() {
    return _copyProgressChannel.receiveBroadcastStream().map((event) {
      final map = (event as Map).cast<Object?, Object?>();
      if (map['phase'] == 'search') {
        return CopyDirProgress.searching(map['name'] as String? ?? '');
      }
      return CopyDirProgress.copying(
        map['name'] as String? ?? '',
        (map['progress'] as num?)?.toInt() ?? 0,
        (map['max'] as num?)?.toInt() ?? 0,
      );
    });
  }

  Stream<ShaderCacheProgress> shaderCacheProgress() {
    return _shaderProgressChannel.receiveBroadcastStream().map((event) {
      final map = (event as Map).cast<Object?, Object?>();
      return ShaderCacheProgress(
        stage: ShaderCacheStage.values.byName(
          (map['stage'] as String).toLowerCase(),
        ),
        progress: (map['progress'] as num).toInt(),
        max: (map['max'] as num).toInt(),
      );
    });
  }

  Future<String?> openUserDirectory() {
    return _channel.invokeMethod<String>('openUserDirectory');
  }

  Future<void> confirmUserDirectory({
    required String uri,
    String? previousUri,
    required bool moveData,
  }) {
    return _channel.invokeMethod<void>('confirmUserDirectory', {
      'uri': uri,
      'previousUri': previousUri,
      'moveData': moveData,
    });
  }

  Future<bool> hasUserDirectoryWriteAccess() async {
    final result = await _channel.invokeMethod<bool>('hasUserDirectoryWriteAccess');
    return result ?? false;
  }

  Future<String?> openGamesDirectory() {
    return _channel.invokeMethod<String>('openGamesDirectory');
  }

  Future<List<Game>> getGames() async {
    final result = await _channel.invokeMethod<List<Object?>>('getGames');
    if (result == null) return const [];
    return result
        .cast<Map<Object?, Object?>>()
        .map((entry) => _gameFromMap(entry))
        .toList();
  }

  Future<int> createEmulationTexture({
    required int width,
    required int height,
    bool secondary = false,
  }) async {
    final result = await _channel.invokeMethod<int>('createEmulationTexture', {
      'width': width,
      'height': height,
      'secondary': secondary,
    });
    return result ?? -1;
  }

  Future<void> startEmulation(String path) {
    return _channel.invokeMethod<void>('startEmulation', {'path': path});
  }

  Future<void> pauseEmulation() {
    return _channel.invokeMethod<void>('pauseEmulation');
  }

  Future<void> resumeEmulation() {
    return _channel.invokeMethod<void>('resumeEmulation');
  }

  Future<void> stopEmulation() {
    return _channel.invokeMethod<void>('stopEmulation');
  }

  Future<bool> onTouchEvent({required double x, required double y, required bool pressed}) async {
    final result = await _channel.invokeMethod<bool>('onTouchEvent', {
      'x': x,
      'y': y,
      'pressed': pressed,
    });
    return result ?? false;
  }

  Future<void> onTouchMoved({required double x, required double y}) {
    return _channel.invokeMethod<void>('onTouchMoved', {'x': x, 'y': y});
  }

  Future<bool> swapScreens() async {
    final result = await _channel.invokeMethod<bool>('swapScreens');
    return result ?? false;
  }

  Game _gameFromMap(Map<Object?, Object?> map) {
    return Game(
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      path: map['path'] as String? ?? '',
      titleId: (map['titleId'] as num?)?.toInt() ?? 0,
      company: map['company'] as String? ?? '',
      regions: map['regions'] as String? ?? '',
      isInstalled: map['isInstalled'] as bool? ?? false,
      isSystemTitle: map['isSystemTitle'] as bool? ?? false,
      isVisibleSystemTitle: map['isVisibleSystemTitle'] as bool? ?? false,
      filename: map['filename'] as String? ?? '',
      iconPath: map['iconPath'] as String?,
    );
  }
}
