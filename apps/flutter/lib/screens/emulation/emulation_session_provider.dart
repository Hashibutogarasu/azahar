import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../app_services.dart';
import '../../data/games/game_title_provider.dart';
import '../../data/settings/media_volume_provider.dart';
import '../../data/settings/sections/media_settings.dart';
import 'emulation_screens_layout.dart';
import 'emulation_session_state.dart';
import 'media_session_metadata.dart';
import 'media_session_service.dart';

final emulationSessionProvider =
    NotifierProvider.autoDispose<
      EmulationSessionNotifier,
      EmulationSessionState
    >(EmulationSessionNotifier.new);

class EmulationSessionNotifier extends Notifier<EmulationSessionState> {
  NativeBridge get _bridge => AppServices.nativeBridge;
  StreamSubscription<ShaderCacheProgress>? _shaderProgressSubscription;
  StreamSubscription<void>? _closeRequestSubscription;
  final _mediaSession = MediaSessionService();
  bool _mediaSessionActivated = false;

  bool get _treatAsMediaSession => AppServices.emulatorSettingsRepository
      .readBool(MediaSettingKeys.treatAudioAsMediaSession);

  @override
  EmulationSessionState build() {
    ref.onDispose(_teardownNativeSession);
    _closeRequestSubscription = _bridge.closeRequests.listen(
      (_) => unawaited(terminate()),
    );
    ref.onDispose(() => _closeRequestSubscription?.cancel());
    return const EmulationSessionState();
  }

  Future<void> launch({
    required String gamePath,
    required EmulationScreensLayout layout,
    required double devicePixelRatio,
  }) async {
    if (state.isLaunched) return;

    await AppServices.emulatorSettingsRepository.load();
    await _syncVirtualAccessPoints();

    _shaderProgressSubscription = _bridge.shaderCacheProgress().listen((
      progress,
    ) {
      switch (progress.stage) {
        case ShaderCacheStage.prepare:
          return;
        case ShaderCacheStage.decompile:
        case ShaderCacheStage.build:
          state = state.copyWith(shaderProgress: progress);
        case ShaderCacheStage.complete:
          state = state.copyWith(emulationStarted: true);
      }
    });

    final topTextureId = await _bridge.createEmulationTexture(
      width: (layout.topScreen.width * devicePixelRatio).round(),
      height: (layout.topScreen.height * devicePixelRatio).round(),
    );
    final bottomWidth = (layout.bottomScreen.width * devicePixelRatio).round();
    final bottomHeight = (layout.bottomScreen.height * devicePixelRatio)
        .round();
    final bottomTextureId = await _bridge.createEmulationTexture(
      width: bottomWidth,
      height: bottomHeight,
      secondary: true,
    );

    state = state.copyWith(
      topTextureId: topTextureId,
      bottomTextureId: bottomTextureId,
      bottomTextureSize: Size(bottomWidth.toDouble(), bottomHeight.toDouble()),
      isLaunched: true,
    );
    await _bridge.startEmulation(gamePath);
  }

  /// The emulation core runs in its own process, so the native virtual access point override set
  /// from the settings screen (running in the main process) never reaches it. Re-apply the
  /// persisted override here before starting emulation.
  Future<void> _syncVirtualAccessPoints() async {
    final enabled = await AppServices.virtualAccessPointsRepository.isEnabled();
    if (!enabled) return;
    final accessPoints = await AppServices.virtualAccessPointsRepository
        .readAll();
    await _bridge.setVirtualAccessPoints(accessPoints);
  }

  Future<void> activateMediaSessionIfNeeded(Game? game) async {
    if (!state.isLaunched || game == null) return;
    if (_mediaSessionActivated) return;
    if (!_treatAsMediaSession) return;
    _mediaSessionActivated = true;
    await _mediaSession.activate(
      MediaSessionMetadata(
        title: ref.read(gameTitleProvider(game.path)),
        artworkPath: game.iconPath,
      ),
      isPlaying: !state.isPaused,
      onStop: () => unawaited(terminate()),
      onPlay: () {
        if (!state.isPaused) return;
        unawaited(togglePause());
      },
      onPause: () {
        if (state.isPaused) return;
        unawaited(togglePause());
      },
    );
    await ref.read(masterVolumeProvider.notifier).startNativeSync();
  }

  Future<void> togglePause() async {
    if (state.isPaused) {
      await _bridge.resumeEmulation();
    } else {
      await _bridge.pauseEmulation();
    }
    state = state.copyWith(isPaused: !state.isPaused, isAutoPaused: false);
    await _mediaSession.updatePlaybackState(isPlaying: !state.isPaused);
  }

  Future<void> advanceFrame() => _bridge.advanceFrame();

  Future<void> pauseForClosePrompt() => _bridge.pauseEmulation();

  Future<void> cancelClosePrompt() => _bridge.resumeEmulation();

  Future<void> handleAppBackground() async {
    if (!state.isLaunched) return;
    await _bridge.pauseRendering();
    if (state.isPaused) return;
    if (_treatAsMediaSession) return;
    await _bridge.pauseEmulation();
    state = state.copyWith(isPaused: true, isAutoPaused: true);
  }

  Future<void> handleAppForeground() async {
    if (!state.isLaunched) return;
    await _bridge.resumeRendering();
    if (!state.isAutoPaused) return;
    await _bridge.resumeEmulation();
    state = state.copyWith(isPaused: false, isAutoPaused: false);
  }

  Offset? _toSurfacePosition(Offset position, Size screenSize) {
    final textureSize = state.bottomTextureSize;
    if (textureSize == null || screenSize.isEmpty) return null;
    return Offset(
      position.dx * textureSize.width / screenSize.width,
      position.dy * textureSize.height / screenSize.height,
    );
  }

  void touchPressed(Offset position, Size screenSize) {
    final surfacePosition = _toSurfacePosition(position, screenSize);
    if (surfacePosition == null) return;
    _bridge.onTouchEvent(
      x: surfacePosition.dx,
      y: surfacePosition.dy,
      pressed: true,
    );
  }

  void touchMoved(Offset position, Size screenSize) {
    final surfacePosition = _toSurfacePosition(position, screenSize);
    if (surfacePosition == null) return;
    _bridge.onTouchMoved(x: surfacePosition.dx, y: surfacePosition.dy);
  }

  void touchReleased() {
    _bridge.onTouchEvent(x: 0, y: 0, pressed: false);
  }

  /// Presses or releases [button] on the console.
  void sendGamePadButton(GamePadButton button, {required bool pressed}) {
    unawaited(
      _bridge.sendGamePadEvent(GamePadContext.button(button, pressed: pressed)),
    );
  }

  /// Moves [axis] to the position ([x], [y]), each from -1.0 to 1.0 with y positive upwards.
  void sendGamePadAxis(GamePadAxis axis, double x, double y) {
    unawaited(_bridge.sendGamePadEvent(GamePadContext.axis(axis, x: x, y: y)));
  }

  /// Gives the latest motion sensor sample, in g and degrees per second.
  void sendMotion({required Vec3 accel, required Vec3 gyro}) {
    unawaited(
      _bridge.sendGamePadEvent(GamePadContext.motion(accel: accel, gyro: gyro)),
    );
  }

  Future<void> swapScreens() async {
    final swapped = await _bridge.swapScreens();
    state = state.copyWith(isScreensSwapped: swapped);
  }

  Future<void> terminate() async {
    if (state.isTerminating) return;
    state = state.copyWith(isTerminating: true);
    await _releaseNativeSession();
    state = state.copyWith(isClosingWindow: true);
    await WidgetsBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;
    await _bridge.terminateProcess();
  }

  Future<void> _teardownNativeSession() async {
    await _releaseNativeSession();
    await _bridge.terminateProcess();
  }

  Future<void> _releaseNativeSession() async {
    await _shaderProgressSubscription?.cancel();
    _shaderProgressSubscription = null;
    _mediaSessionActivated = false;
    await ref.read(masterVolumeProvider.notifier).stopNativeSync();
    await _mediaSession.deactivate();
    if (state.isLaunched) {
      await _bridge.stopEmulation();
    }
  }
}
