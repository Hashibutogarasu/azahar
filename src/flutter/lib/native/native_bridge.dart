import 'package:flutter/services.dart';

import '../models/access_point.dart';
import '../models/cia_install_result.dart';
import '../models/copy_dir_progress.dart';
import '../models/create_shortcut_request.dart';
import '../models/game.dart';
import '../models/game_folder_kind.dart';
import '../models/game_folder_status.dart';
import '../models/game_uninstall_target.dart';
import '../models/gpu_driver_info.dart';
import '../models/shader_cache_backend.dart';
import '../models/shader_cache_progress.dart';
import '../models/wifi_channel.dart';

class NativeBridge {
  NativeBridge()
      : _channel = const MethodChannel('org.citra.citra_emu/azahar_bridge'),
        _shaderProgressChannel =
            const EventChannel('org.citra.citra_emu/azahar_bridge/shader_progress'),
        _copyProgressChannel =
            const EventChannel('org.citra.citra_emu/azahar_bridge/copy_progress'),
        _systemVolumeChannel =
            const EventChannel('org.citra.citra_emu/azahar_bridge/system_volume'),
        _mediaNotificationStopChannel =
            const EventChannel('org.citra.citra_emu/azahar_bridge/media_notification_stop'),
        _mediaNotificationPlayPauseChannel = const EventChannel(
          'org.citra.citra_emu/azahar_bridge/media_notification_play_pause',
        );

  final MethodChannel _channel;
  final EventChannel _shaderProgressChannel;
  final EventChannel _copyProgressChannel;
  final EventChannel _mediaNotificationStopChannel;
  final EventChannel _mediaNotificationPlayPauseChannel;
  final EventChannel _systemVolumeChannel;

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

  Future<bool> shareLog() async {
    final result = await _channel.invokeMethod<bool>('shareLog');
    return result ?? false;
  }

  Future<List<CiaInstallResult>> installCiaFiles(List<String> paths) async {
    final result = await _channel.invokeMethod<List<Object?>>('installCiaFiles', {
      'paths': paths,
    });
    if (result == null) return const [];
    return result.cast<Map<Object?, Object?>>().map((entry) {
      return CiaInstallResult(
        filename: entry['filename'] as String? ?? '',
        success: entry['success'] as bool? ?? false,
      );
    }).toList();
  }

  Future<void> showNotification({required String title, String body = ''}) {
    return _channel.invokeMethod<void>('showNotification', {
      'title': title,
      'body': body,
    });
  }

  Future<bool> isFullConsoleLinked() async {
    final result = await _channel.invokeMethod<bool>('isFullConsoleLinked');
    return result ?? false;
  }

  Future<List<bool>> areSystemTitlesInstalled() async {
    final result = await _channel.invokeMethod<List<Object?>>('areSystemTitlesInstalled');
    return result?.cast<bool>() ?? const [false, false];
  }

  Future<void> installSystemFiles(bool old3ds) {
    return _channel.invokeMethod<void>('installSystemFiles', {'old3ds': old3ds});
  }

  Future<void> unlinkConsole() {
    return _channel.invokeMethod<void>('unlinkConsole');
  }

  Future<String> getHomeMenuPath(int region) async {
    final result = await _channel.invokeMethod<String>('getHomeMenuPath', {'region': region});
    return result ?? '';
  }

  Future<bool> isSystemSetupNeeded() async {
    final result = await _channel.invokeMethod<bool>('isSystemSetupNeeded');
    return result ?? false;
  }

  Future<void> setSystemSetupNeeded(bool needed) {
    return _channel.invokeMethod<void>('setSystemSetupNeeded', {'needed': needed});
  }

  Future<List<Game>> getGames(String? gamesDirectory) async {
    final result = await _channel.invokeMethod<List<Object?>>('getGames', {
      'gamesDirectory': gamesDirectory,
    });
    if (result == null) return const [];
    return result
        .cast<Map<Object?, Object?>>()
        .map((entry) => _gameFromMap(entry))
        .toList();
  }

  Future<List<AccessPoint>> scanRealWifiAccessPoints() async {
    final result = await _channel.invokeMethod<List<Object?>>('scanRealWifiAccessPoints');
    if (result == null) return const [];
    return result.cast<Map<Object?, Object?>>().map((entry) => _accessPointFromMap(entry)).toList();
  }

  Future<void> setVirtualAccessPoints(List<AccessPoint>? accessPoints) {
    return _channel.invokeMethod<void>('setVirtualAccessPoints', {
      'accessPoints': accessPoints
          ?.map(
            (accessPoint) => {
              'ssid': accessPoint.ssid,
              'bssid': accessPoint.bssid,
              'frequency': accessPoint.frequency,
              'channel': wifiFrequencyToChannel(accessPoint.frequency),
              'level': accessPoint.level,
            },
          )
          .toList(),
    });
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

  Future<void> pauseRendering() {
    return _channel.invokeMethod<void>('pauseRendering');
  }

  Future<void> resumeRendering() {
    return _channel.invokeMethod<void>('resumeRendering');
  }

  Future<void> stopEmulation() {
    return _channel.invokeMethod<void>('stopEmulation');
  }

  Future<double> getSystemMediaVolume() async {
    final result = await _channel.invokeMethod<double>('getSystemMediaVolume');
    return result ?? 0;
  }

  Future<void> setSystemMediaVolume(double volume) {
    return _channel.invokeMethod<void>('setSystemMediaVolume', {'volume': volume});
  }

  Stream<double> systemMediaVolumeChanges() {
    return _systemVolumeChannel.receiveBroadcastStream().map((event) => (event as num).toDouble());
  }

  Future<void> activateMediaNotification({
    required String title,
    String? artworkPath,
    required bool isPlaying,
  }) {
    return _channel.invokeMethod<void>('activateMediaNotification', {
      'title': title,
      'artworkPath': artworkPath,
      'isPlaying': isPlaying,
    });
  }

  Future<void> updateMediaNotificationPlaybackState({required bool isPlaying}) {
    return _channel.invokeMethod<void>('updateMediaNotificationPlaybackState', {
      'isPlaying': isPlaying,
    });
  }

  Future<void> deactivateMediaNotification() {
    return _channel.invokeMethod<void>('deactivateMediaNotification');
  }

  Stream<void> mediaNotificationStopRequests() {
    return _mediaNotificationStopChannel.receiveBroadcastStream().map((_) {});
  }

  Stream<bool> mediaNotificationPlayPauseRequests() {
    return _mediaNotificationPlayPauseChannel.receiveBroadcastStream().map(
          (event) => event as bool,
        );
  }

  Future<void> launchEmulationActivity(String gamePath) {
    return _channel.invokeMethod<void>('launchEmulationActivity', {'path': gamePath});
  }

  Future<void> terminateProcess() {
    return _channel.invokeMethod<void>('terminateProcess');
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

  Future<Map<String, Map<String, String>>> readEmulatorConfig() async {
    final result = await _channel.invokeMethod<Map<Object?, Object?>>('readEmulatorConfig');
    if (result == null) return const {};
    return result.map(
      (section, keys) => MapEntry(
        section as String,
        (keys as Map<Object?, Object?>).cast<String, String>(),
      ),
    );
  }

  Future<void> writeEmulatorConfig(Map<String, Map<String, String>> sections) {
    return _channel.invokeMethod<void>('writeEmulatorConfig', sections);
  }

  Future<void> reloadEmulatorSettings() {
    return _channel.invokeMethod<void>('reloadEmulatorSettings');
  }

  Future<Map<String, Object?>> readSystemSaveGame() async {
    final result = await _channel.invokeMethod<Map<Object?, Object?>>('readSystemSaveGame');
    if (result == null) return const {};
    return result.cast<String, Object?>();
  }

  Future<void> writeSystemSaveGame(Map<String, Object?> fields) {
    return _channel.invokeMethod<void>('writeSystemSaveGame', fields);
  }

  Future<String> regenerateConsoleId() async {
    final result = await _channel.invokeMethod<String>('regenerateConsoleId');
    return result ?? '';
  }

  Future<String> regenerateMac() async {
    final result = await _channel.invokeMethod<String>('regenerateMac');
    return result ?? '';
  }

  Future<int> getCountryCompatibility(int region) async {
    final result = await _channel.invokeMethod<int>('getCountryCompatibility', region);
    return result ?? 0;
  }

  Future<bool> supportsCustomDriverLoading() async {
    final result = await _channel.invokeMethod<bool>('supportsCustomDriverLoading');
    return result ?? false;
  }

  Future<List<GpuDriverInfo>> listGpuDrivers() async {
    final result = await _channel.invokeMethod<List<Object?>>('listGpuDrivers');
    if (result == null) return const [];
    return result.cast<Map<Object?, Object?>>().map((entry) {
      return GpuDriverInfo(
        uri: entry['uri'] as String? ?? '',
        name: entry['name'] as String?,
        description: entry['description'] as String?,
        author: entry['author'] as String?,
        vendor: entry['vendor'] as String?,
        version: entry['version'] as String?,
      );
    }).toList();
  }

  Future<String?> getSelectedGpuDriver() {
    return _channel.invokeMethod<String>('getSelectedGpuDriver');
  }

  Future<bool> installGpuDriver(String path) async {
    final result = await _channel.invokeMethod<bool>('installGpuDriver', {'path': path});
    return result ?? false;
  }

  Future<bool> selectGpuDriver(String? uri) async {
    final result = await _channel.invokeMethod<bool>('selectGpuDriver', {'uri': uri});
    return result ?? false;
  }

  Future<GameFolderStatus> getGameFolderStatus(Game game) async {
    final result = await _channel.invokeMethod<List<Object?>>('getGameFolderStatus', {
      'titleId': game.titleId,
      'path': game.path,
    });
    final flags = result?.cast<bool>() ?? List<bool>.filled(GameFolderKind.values.length, false);
    return GameFolderStatus(
      app: flags[GameFolderKind.app.index],
      save: flags[GameFolderKind.save.index],
      updates: flags[GameFolderKind.updates.index],
      dlc: flags[GameFolderKind.dlc.index],
      extra: flags[GameFolderKind.extra.index],
      textures: flags[GameFolderKind.textures.index],
      mods: flags[GameFolderKind.mods.index],
    );
  }

  Future<bool> openGameFolder(Game game, GameFolderKind folder) async {
    final result = await _channel.invokeMethod<bool>('openGameFolder', {
      'titleId': game.titleId,
      'path': game.path,
      'folder': folder.name,
    });
    return result ?? false;
  }

  Future<bool> deleteGameFolder(Game game, GameUninstallTarget target) async {
    final result = await _channel.invokeMethod<bool>('deleteGameFolder', {
      'titleId': game.titleId,
      'path': game.path,
      'target': target.name,
    });
    return result ?? false;
  }

  Future<void> deleteShaderCache(Game game, ShaderCacheBackend backend) {
    return _channel.invokeMethod<void>('deleteShaderCache', {
      'titleId': game.titleId,
      'backend': backend.name,
    });
  }

  Future<void> createGameShortcut(CreateShortcutRequest request) {
    return _channel.invokeMethod<void>('createGameShortcut', {
      'titleId': request.titleId,
      'path': request.path,
      'name': request.name,
      'iconFilePath': request.iconFilePath,
      'stretch': request.stretch,
    });
  }

  Future<bool> hasPermission(String permission) async {
    final result = await _channel.invokeMethod<bool>('hasPermission', {
      'permission': permission,
    });
    return result ?? false;
  }

  Future<bool> requestPermission(String permission) async {
    final result = await _channel.invokeMethod<bool>('requestPermission', {
      'permission': permission,
    });
    return result ?? false;
  }

  AccessPoint _accessPointFromMap(Map<Object?, Object?> map) {
    return AccessPoint(
      ssid: map['ssid'] as String? ?? '',
      bssid: map['bssid'] as String? ?? '',
      frequency: (map['frequency'] as num?)?.toInt() ?? 0,
      level: (map['level'] as num?)?.toInt() ?? 0,
    );
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
