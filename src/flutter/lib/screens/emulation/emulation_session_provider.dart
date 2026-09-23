import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../models/shader_cache_progress.dart';
import '../../native/native_bridge.dart';
import 'emulation_screens_layout.dart';
import 'emulation_session_state.dart';

final emulationSessionProvider =
    NotifierProvider.autoDispose<EmulationSessionNotifier, EmulationSessionState>(
  EmulationSessionNotifier.new,
);

class EmulationSessionNotifier extends Notifier<EmulationSessionState> {
  NativeBridge get _bridge => AppServices.nativeBridge;
  StreamSubscription<ShaderCacheProgress>? _shaderProgressSubscription;

  @override
  EmulationSessionState build() {
    ref.onDispose(_teardownNativeSession);
    return const EmulationSessionState();
  }

  Future<void> launch({
    required String gamePath,
    required EmulationScreensLayout layout,
    required double devicePixelRatio,
  }) async {
    if (state.isLaunched) return;

    _shaderProgressSubscription = _bridge.shaderCacheProgress().listen((progress) {
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
    final bottomHeight = (layout.bottomScreen.height * devicePixelRatio).round();
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

  Future<void> togglePause() async {
    if (state.isPaused) {
      await _bridge.resumeEmulation();
    } else {
      await _bridge.pauseEmulation();
    }
    state = state.copyWith(isPaused: !state.isPaused);
  }

  Future<void> pauseForClosePrompt() => _bridge.pauseEmulation();

  Future<void> cancelClosePrompt() => _bridge.resumeEmulation();

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
    _bridge.onTouchEvent(x: surfacePosition.dx, y: surfacePosition.dy, pressed: true);
  }

  void touchMoved(Offset position, Size screenSize) {
    final surfacePosition = _toSurfacePosition(position, screenSize);
    if (surfacePosition == null) return;
    _bridge.onTouchMoved(x: surfacePosition.dx, y: surfacePosition.dy);
  }

  void touchReleased() {
    _bridge.onTouchEvent(x: 0, y: 0, pressed: false);
  }

  Future<void> swapScreens() async {
    final swapped = await _bridge.swapScreens();
    state = state.copyWith(isScreensSwapped: swapped);
  }

  Future<void> terminate() async {
    await _teardownNativeSession();
    state = const EmulationSessionState();
  }

  Future<void> _teardownNativeSession() async {
    await _shaderProgressSubscription?.cancel();
    _shaderProgressSubscription = null;
    if (state.isLaunched) {
      await _bridge.stopEmulation();
    }
    await _bridge.terminateProcess();
  }
}
