import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../models/shader_cache_progress.dart';
import '../../native/native_bridge.dart';
import 'emulation_screens_layout.dart';

class EmulationViewModel extends ChangeNotifier {
  EmulationViewModel(this._nativeBridge);

  final NativeBridge _nativeBridge;

  int? topTextureId;
  int? bottomTextureId;
  Size? _bottomTextureSize;
  bool isPaused = false;
  bool isScreensSwapped = false;
  bool emulationStarted = false;
  ShaderCacheProgress? shaderProgress;
  StreamSubscription<ShaderCacheProgress>? _shaderProgressSubscription;

  void start(
    String gamePath, {
    required EmulationScreensLayout layout,
    required double devicePixelRatio,
  }) {
    _shaderProgressSubscription = _nativeBridge.shaderCacheProgress().listen((progress) {
      switch (progress.stage) {
        case ShaderCacheStage.prepare:
          return;
        case ShaderCacheStage.decompile:
        case ShaderCacheStage.build:
          shaderProgress = progress;
        case ShaderCacheStage.complete:
          emulationStarted = true;
      }
      notifyListeners();
    });
    _startEmulation(gamePath, layout: layout, devicePixelRatio: devicePixelRatio);
  }

  Future<void> _startEmulation(
    String gamePath, {
    required EmulationScreensLayout layout,
    required double devicePixelRatio,
  }) async {
    topTextureId = await _nativeBridge.createEmulationTexture(
      width: (layout.topScreen.width * devicePixelRatio).round(),
      height: (layout.topScreen.height * devicePixelRatio).round(),
    );
    final bottomWidth = (layout.bottomScreen.width * devicePixelRatio).round();
    final bottomHeight = (layout.bottomScreen.height * devicePixelRatio).round();
    bottomTextureId = await _nativeBridge.createEmulationTexture(
      width: bottomWidth,
      height: bottomHeight,
      secondary: true,
    );
    _bottomTextureSize = Size(bottomWidth.toDouble(), bottomHeight.toDouble());
    await _nativeBridge.startEmulation(gamePath);
    notifyListeners();
  }

  Future<void> togglePause() async {
    if (isPaused) {
      await _nativeBridge.resumeEmulation();
    } else {
      await _nativeBridge.pauseEmulation();
    }
    isPaused = !isPaused;
    notifyListeners();
  }

  /// Pauses emulation while a close-game confirmation is shown, independently of [isPaused]'s
  /// pause button state.
  Future<void> pauseForClosePrompt() => _nativeBridge.pauseEmulation();

  /// Resumes emulation after a close-game confirmation was cancelled.
  Future<void> cancelClosePrompt() => _nativeBridge.resumeEmulation();

  /// Converts [position], local to the bottom screen widget of [screenSize], into the pixel
  /// coordinates of the bottom screen surface that the native side expects.
  Offset? _toSurfacePosition(Offset position, Size screenSize) {
    final textureSize = _bottomTextureSize;
    if (textureSize == null || screenSize.isEmpty) return null;
    return Offset(
      position.dx * textureSize.width / screenSize.width,
      position.dy * textureSize.height / screenSize.height,
    );
  }

  /// Sends a touch press at [position], local to the bottom screen widget of [screenSize].
  void touchPressed(Offset position, Size screenSize) {
    final surfacePosition = _toSurfacePosition(position, screenSize);
    if (surfacePosition == null) return;
    _nativeBridge.onTouchEvent(x: surfacePosition.dx, y: surfacePosition.dy, pressed: true);
  }

  /// Sends a touch move to [position], local to the bottom screen widget of [screenSize].
  void touchMoved(Offset position, Size screenSize) {
    final surfacePosition = _toSurfacePosition(position, screenSize);
    if (surfacePosition == null) return;
    _nativeBridge.onTouchMoved(x: surfacePosition.dx, y: surfacePosition.dy);
  }

  /// Sends a touch release to the native side.
  void touchReleased() {
    _nativeBridge.onTouchEvent(x: 0, y: 0, pressed: false);
  }

  Future<void> swapScreens() async {
    isScreensSwapped = await _nativeBridge.swapScreens();
    notifyListeners();
  }

  Future<void> stopEmulation() {
    return _nativeBridge.stopEmulation();
  }

  @override
  void dispose() {
    _shaderProgressSubscription?.cancel();
    _nativeBridge.stopEmulation();
    super.dispose();
  }
}
