import 'dart:async';
import 'dart:ui';

import 'package:azahar_for_flutter/azahar_for_flutter.dart';

/// Receives what an [EmulationBackend] reports while a game is running.
class EmulationBackendListener {
  const EmulationBackendListener({
    required this.onTexture,
    required this.onShaderProgress,
    required this.onError,
  });

  /// Called when a screen texture is ready to be shown.
  final void Function(int textureId, {required bool secondary}) onTexture;

  /// Called while the shader cache is prepared.
  final void Function(ShaderCacheProgress progress) onShaderProgress;

  /// Called when the backend reports a failure.
  final void Function(String message) onError;
}

/// Starts, pauses, resumes and stops one game in a session owned by the `azahar_rust` crate.
///
/// The session releases the whole emulated console when it is stopped, so another game can be
/// started in the same process afterwards.
class EmulationBackend {
  StreamSubscription<SessionEvent>? _subscription;
  bool _started = false;

  Future<void> start({
    required String gamePath,
    required Size topScreenSize,
    required Size bottomScreenSize,
    required EmulationBackendListener listener,
  }) async {
    _subscription = startGame(
      gamePath: gamePath,
      options: SessionOptions(
        primaryWidth: topScreenSize.width.round(),
        primaryHeight: topScreenSize.height.round(),
        secondaryWidth: bottomScreenSize.width.round(),
        secondaryHeight: bottomScreenSize.height.round(),
        dualScreen: true,
      ),
    ).listen(
      (event) => _dispatch(event, listener),
      onError: (Object error) => listener.onError(error.toString()),
    );
    _started = true;
  }

  void _dispatch(SessionEvent event, EmulationBackendListener listener) {
    switch (event) {
      case SessionEvent_ShaderProgress(:final stage, :final progress, :final max):
        listener.onShaderProgress(
          ShaderCacheProgress(
            stage: switch (stage) {
              ShaderStage.prepare => ShaderCacheStage.prepare,
              ShaderStage.decompile => ShaderCacheStage.decompile,
              ShaderStage.build => ShaderCacheStage.build,
              ShaderStage.complete => ShaderCacheStage.complete,
            },
            progress: progress.toInt(),
            max: max.toInt(),
          ),
        );
      case SessionEvent_Texture(:final textureId, :final secondary):
        listener.onTexture(textureId, secondary: secondary);
      case SessionEvent_StateChanged():
        break;
      case SessionEvent_Error(:final message):
        listener.onError(message);
    }
  }

  Future<void> pause() => pauseGame();

  Future<void> resume() => resumeGame();

  /// Stops the game and returns once every native resource is released.
  Future<void> stop() async {
    if (!_started) return;
    _started = false;
    await stopGame();
    await _subscription?.cancel();
    _subscription = null;
  }
}
