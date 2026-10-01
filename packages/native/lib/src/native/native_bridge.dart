import 'dart:async';

import 'package:flutter/services.dart';

import '../models/access_point.dart';
import '../models/cheat.dart';
import '../models/cia_install_result.dart';
import '../models/copy_dir_progress.dart';
import '../models/create_shortcut_request.dart';
import '../models/game.dart';
import '../models/game_folder_kind.dart';
import '../models/game_folder_status.dart';
import '../models/game_uninstall_target.dart';
import '../models/gamepad_context.dart';
import '../models/gpu_driver_info.dart';
import '../models/installed_title_path.dart';
import '../models/shader_cache_backend.dart';
import '../models/wifi_channel.dart';

class NativeBridge {
  NativeBridge()
    : _channel = const MethodChannel('org.citra.citra_emu/azahar_bridge'),
      _copyProgressChannel = const EventChannel(
        'org.citra.citra_emu/azahar_bridge/copy_progress',
      ),
      _systemVolumeChannel = const EventChannel(
        'org.citra.citra_emu/azahar_bridge/system_volume',
      ),
      _mediaNotificationStopChannel = const EventChannel(
        'org.citra.citra_emu/azahar_bridge/media_notification_stop',
      ),
      _mediaNotificationPlayPauseChannel = const EventChannel(
        'org.citra.citra_emu/azahar_bridge/media_notification_play_pause',
      ),
      _logLinesChannel = const EventChannel(
        'org.citra.citra_emu/azahar_bridge/log_lines',
      ),
      _gamePadChannel = const EventChannel(
        'org.citra.citra_emu/azahar_bridge/gamepad_events',
      ) {
    _channel.setMethodCallHandler(_handleNativeCall);
  }

  final MethodChannel _channel;
  final EventChannel _copyProgressChannel;
  final EventChannel _mediaNotificationStopChannel;
  final EventChannel _mediaNotificationPlayPauseChannel;
  final EventChannel _systemVolumeChannel;
  final EventChannel _logLinesChannel;
  final EventChannel _gamePadChannel;
  final _closeRequestedController = StreamController<void>.broadcast();
  final _launchRequestedController = StreamController<String>.broadcast();

  Stream<void> get closeRequests => _closeRequestedController.stream;

  /// Paths of games the system asked to launch while the app is running, for example from a
  /// pinned shortcut.
  Stream<String> get launchRequests => _launchRequestedController.stream;

  Future<void> _handleNativeCall(MethodCall call) async {
    switch (call.method) {
      case 'requestClose':
        _closeRequestedController.add(null);
      case 'launchGame':
        final path = (call.arguments as Map<Object?, Object?>)['path'];
        if (path is String && path.isNotEmpty) {
          _launchRequestedController.add(path);
        }
    }
  }

  /// Returns the path of the game the app was started to launch, if any, and forgets it.
  Future<String?> takePendingLaunch() {
    return _channel.invokeMethod<String>('takePendingLaunch');
  }

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

  /// Gives [event] to the core as if it came from the console's own buttons, sticks or motion
  /// sensors.
  Future<void> sendGamePadEvent(GamePadContext event) {
    return _channel.invokeMethod<void>('sendGamePadEvent', event.toMap());
  }

  /// Reports every gamepad input the native side handed to the core, whichever source it came
  /// from.
  Stream<GamePadContext> onGamePadEvent() {
    return _gamePadChannel.receiveBroadcastStream().map(
      (event) =>
          GamePadContext.fromMap((event as Map).cast<Object?, Object?>()),
    );
  }

  Future<String?> openUserDirectory() {
    return _channel.invokeMethod<String>('openUserDirectory');
  }

  Future<String?> openGamesDirectory() {
    return _channel.invokeMethod<String>('openGamesDirectory');
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
    final result = await _channel.invokeMethod<bool>(
      'hasUserDirectoryWriteAccess',
    );
    return result ?? false;
  }

  Stream<List<String>> logLines() {
    return _logLinesChannel.receiveBroadcastStream().map(
      (event) => (event as List<Object?>).cast<String>(),
    );
  }

  Future<bool> appendUserFile(String path, String text) async {
    final result = await _channel.invokeMethod<bool>('appendUserFile', {
      'path': path,
      'text': text,
    });
    return result ?? false;
  }

  Future<bool> rotateUserFile(String path, String previousPath) async {
    final result = await _channel.invokeMethod<bool>('rotateUserFile', {
      'path': path,
      'previousPath': previousPath,
    });
    return result ?? false;
  }

  Future<bool> userFileExists(String path) async {
    final result = await _channel.invokeMethod<bool>('userFileExists', {
      'path': path,
    });
    return result ?? false;
  }

  Future<bool> shareUserFile(String path) async {
    final result = await _channel.invokeMethod<bool>('shareUserFile', {
      'path': path,
    });
    return result ?? false;
  }

  Future<List<CiaInstallResult>> installCiaFiles(List<String> paths) async {
    final result = await _channel.invokeMethod<List<Object?>>(
      'installCiaFiles',
      {'paths': paths},
    );
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
    final result = await _channel.invokeMethod<List<Object?>>(
      'areSystemTitlesInstalled',
    );
    return result?.cast<bool>() ?? const [false, false];
  }

  Future<void> installSystemFiles(bool old3ds) {
    return _channel.invokeMethod<void>('installSystemFiles', {
      'old3ds': old3ds,
    });
  }

  Future<void> unlinkConsole() {
    return _channel.invokeMethod<void>('unlinkConsole');
  }

  Future<String> getHomeMenuPath(int region) async {
    final result = await _channel.invokeMethod<String>('getHomeMenuPath', {
      'region': region,
    });
    return result ?? '';
  }

  Future<bool> isSystemSetupNeeded() async {
    final result = await _channel.invokeMethod<bool>('isSystemSetupNeeded');
    return result ?? false;
  }

  Future<void> setSystemSetupNeeded(bool needed) {
    return _channel.invokeMethod<void>('setSystemSetupNeeded', {
      'needed': needed,
    });
  }

  Future<List<Game>> getGames(
    String? gamesDirectory, {
    List<InstalledTitlePath> installedTitlePaths = const [],
  }) async {
    final result = await _channel.invokeMethod<List<Object?>>('getGames', {
      'gamesDirectory': gamesDirectory,
      'installedTitlePaths': installedTitlePaths
          .map((entry) => {'root': entry.root.name, 'path': entry.path})
          .toList(),
    });
    if (result == null) return const [];
    return result
        .cast<Map<Object?, Object?>>()
        .map((entry) => _gameFromMap(entry))
        .toList();
  }

  Future<List<AccessPoint>> scanRealWifiAccessPoints() async {
    final result = await _channel.invokeMethod<List<Object?>>(
      'scanRealWifiAccessPoints',
    );
    if (result == null) return const [];
    return result
        .cast<Map<Object?, Object?>>()
        .map((entry) => _accessPointFromMap(entry))
        .toList();
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

  Future<void> advanceFrame() {
    return _channel.invokeMethod<void>('advanceFrame');
  }

  Future<void> loadCheatFile(int titleId) {
    return _channel.invokeMethod<void>('loadCheatFile', {'titleId': titleId});
  }

  Future<void> saveCheatFile(int titleId) {
    return _channel.invokeMethod<void>('saveCheatFile', {'titleId': titleId});
  }

  Future<List<Cheat>> getCheats() async {
    final result = await _channel.invokeMethod<List<Object?>>('getCheats');
    if (result == null) return const [];
    return result
        .map((entry) => Cheat.fromJson((entry as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<void> setCheatEnabled(int index, bool enabled) {
    return _channel.invokeMethod<void>('setCheatEnabled', {
      'index': index,
      'enabled': enabled,
    });
  }

  Future<void> addCheat({
    required String name,
    required String notes,
    required String code,
  }) {
    return _channel.invokeMethod<void>('addCheat', {
      'name': name,
      'notes': notes,
      'code': code,
    });
  }

  /// Returns 0 when [code] is a valid gateway code, otherwise the 1-based number of the first
  /// invalid line.
  Future<int> validateCheatCode(String code) async {
    final result = await _channel.invokeMethod<int>('validateCheatCode', {
      'code': code,
    });
    return result ?? 0;
  }

  Future<void> pauseRendering() {
    return _channel.invokeMethod<void>('pauseRendering');
  }

  Future<void> resumeRendering() {
    return _channel.invokeMethod<void>('resumeRendering');
  }

  Future<double> getSystemMediaVolume() async {
    final result = await _channel.invokeMethod<double>('getSystemMediaVolume');
    return result ?? 0;
  }

  Future<void> setSystemMediaVolume(double volume) {
    return _channel.invokeMethod<void>('setSystemMediaVolume', {
      'volume': volume,
    });
  }

  Stream<double> systemMediaVolumeChanges() {
    return _systemVolumeChannel.receiveBroadcastStream().map(
      (event) => (event as num).toDouble(),
    );
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

  Future<void> setConsoleLogEnabled(bool enabled) {
    return _channel.invokeMethod<void>('setConsoleLogEnabled', {
      'enabled': enabled,
    });
  }

  Future<bool> onTouchEvent({
    required double x,
    required double y,
    required bool pressed,
  }) async {
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
    final result = await _channel.invokeMethod<Map<Object?, Object?>>(
      'readEmulatorConfig',
    );
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
    final result = await _channel.invokeMethod<Map<Object?, Object?>>(
      'readSystemSaveGame',
    );
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
    final result = await _channel.invokeMethod<int>(
      'getCountryCompatibility',
      region,
    );
    return result ?? 0;
  }

  Future<bool> supportsCustomDriverLoading() async {
    final result = await _channel.invokeMethod<bool>(
      'supportsCustomDriverLoading',
    );
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
    final result = await _channel.invokeMethod<bool>('installGpuDriver', {
      'path': path,
    });
    return result ?? false;
  }

  Future<bool> selectGpuDriver(String? uri) async {
    final result = await _channel.invokeMethod<bool>('selectGpuDriver', {
      'uri': uri,
    });
    return result ?? false;
  }

  Future<GameFolderStatus> getGameFolderStatus(Game game) async {
    final result = await _channel.invokeMethod<List<Object?>>(
      'getGameFolderStatus',
      {'titleId': game.titleId, 'path': game.path},
    );
    final flags =
        result?.cast<bool>() ??
        List<bool>.filled(GameFolderKind.values.length, false);
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
