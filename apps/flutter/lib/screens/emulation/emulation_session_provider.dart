import 'dart:async';
import 'dart:ui' show AppExitType;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../app_services.dart';
import '../../data/games/game_title_provider.dart';
import '../../data/settings/audio_engine_provider.dart';
import '../../data/settings/media_volume_provider.dart';
import '../../data/settings/sections/media_settings.dart';
import 'emulation_backend.dart';
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
  final EmulationBackend _backend = EmulationBackend();
  StreamSubscription<void>? _closeRequestSubscription;
  final _mediaSession = MediaSessionService();
  bool _mediaSessionActivated = false;
  Future<void>? _nativeSessionRelease;

  bool get _treatAsMediaSession => AppServices.emulatorSettingsRepository
      .readBool(MediaSettingKeys.treatAudioAsMediaSession);

  @override
  EmulationSessionState build() {
    ref.onDispose(_teardownNativeSession);
    _closeRequestSubscription = _bridge.closeRequests.listen(
      (_) => unawaited(_exitApplication()),
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

    final topSize = Size(
      (layout.topScreen.width * devicePixelRatio).roundToDouble(),
      (layout.topScreen.height * devicePixelRatio).roundToDouble(),
    );
    final bottomSize = Size(
      (layout.bottomScreen.width * devicePixelRatio).roundToDouble(),
      (layout.bottomScreen.height * devicePixelRatio).roundToDouble(),
    );

    final audioEngine = await ref.read(audioEngineProvider.notifier).read();

    state = state.copyWith(bottomTextureSize: bottomSize, isLaunched: true);
    await _backend.start(
      gamePath: gamePath,
      topScreenSize: topSize,
      bottomScreenSize: bottomSize,
      audioEngine: audioEngine,
      listener: EmulationBackendListener(
        onTexture: (textureId, {required secondary}) {
          state = secondary
              ? state.copyWith(bottomTextureId: textureId)
              : state.copyWith(topTextureId: textureId);
        },
        onShaderProgress: (progress) {
          switch (progress.stage) {
            case ShaderCacheStage.prepare:
              return;
            case ShaderCacheStage.decompile:
            case ShaderCacheStage.build:
              state = state.copyWith(shaderProgress: progress);
            case ShaderCacheStage.complete:
              state = state.copyWith(emulationStarted: true);
          }
        },
        onError: (message) => debugPrint('Emulation error: $message'),
      ),
    );
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
      await _backend.resume();
    } else {
      await _backend.pause();
    }
    state = state.copyWith(isPaused: !state.isPaused, isAutoPaused: false);
    await _mediaSession.updatePlaybackState(isPlaying: !state.isPaused);
  }

  Future<void> advanceFrame() => _bridge.advanceFrame();

  /// Pauses the game while a dialog is shown over it, the same way as [togglePause], so the menu
  /// shows it as paused. Returns whether the game was running, to pass to [resumeAfterDialog].
  Future<bool> pauseForDialog() async {
    if (state.isPaused) return false;
    await togglePause();
    return true;
  }

  /// Resumes the game after a dialog when [pauseForDialog] paused it.
  Future<void> resumeAfterDialog({required bool wasRunning}) async {
    if (!wasRunning || !state.isPaused) return;
    await togglePause();
  }

  Future<void> handleAppBackground() async {
    if (!state.isLaunched) return;
    await _bridge.pauseRendering();
    if (state.isPaused) return;
    if (_treatAsMediaSession) return;
    await _backend.pause();
    state = state.copyWith(isPaused: true, isAutoPaused: true);
  }

  Future<void> handleAppForeground() async {
    if (!state.isLaunched) return;
    await _bridge.resumeRendering();
    if (!state.isAutoPaused) return;
    await _backend.resume();
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
    state = state.copyWith(isFinished: true);
  }

  /// Stops the game and returns once the native session has released everything, without leaving
  /// the screen. Used right before the application exits.
  Future<void> stopForExit() => _releaseNativeSession();

  /// Asks the application to exit. The game is stopped first, see [stopForExit].
  Future<void> _exitApplication() {
    return ServicesBinding.instance.exitApplication(AppExitType.cancelable);
  }

  Future<void> _teardownNativeSession() => _releaseNativeSession();

  Future<void> _releaseNativeSession() => _nativeSessionRelease ??= _performRelease();

  Future<void> _performRelease() async {
    _mediaSessionActivated = false;
    await ref.read(masterVolumeProvider.notifier).stopNativeSync();
    await _mediaSession.deactivate();
    if (state.isLaunched) {
      await _backend.stop();
    }
  }
}
