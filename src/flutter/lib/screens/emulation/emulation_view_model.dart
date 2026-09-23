import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../models/shader_cache_progress.dart';
import '../../native/native_bridge.dart';

class EmulationViewModel extends ChangeNotifier {
  EmulationViewModel(this._nativeBridge);

  static const double _topScreenWidth = 400;
  static const double _topScreenHeight = 240;
  static const double _bottomScreenWidth = 320;
  static const double _bottomScreenHeight = 240;

  final NativeBridge _nativeBridge;

  int? topTextureId;
  int? bottomTextureId;
  double topScreenWidth = 0;
  double topScreenHeight = 0;
  double bottomScreenWidth = 0;
  double bottomScreenHeight = 0;
  bool isPaused = false;
  bool isScreensSwapped = false;
  bool emulationStarted = false;
  ShaderCacheProgress? shaderProgress;
  StreamSubscription<ShaderCacheProgress>? _shaderProgressSubscription;

  void start(
    String gamePath, {
    required double maxWidth,
    required double maxHeight,
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
    _startEmulation(
      gamePath,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      devicePixelRatio: devicePixelRatio,
    );
  }

  Future<void> _startEmulation(
    String gamePath, {
    required double maxWidth,
    required double maxHeight,
    required double devicePixelRatio,
  }) async {
    final combinedWidth = _topScreenWidth;
    final combinedHeight =
        _topScreenHeight + _topScreenWidth * (_bottomScreenHeight / _bottomScreenWidth);
    final zoom = min(maxWidth / combinedWidth, maxHeight / combinedHeight);

    topScreenWidth = zoom * _topScreenWidth;
    topScreenHeight = zoom * _topScreenHeight;
    bottomScreenWidth = topScreenWidth;
    bottomScreenHeight = topScreenWidth * (_bottomScreenHeight / _bottomScreenWidth);

    topTextureId = await _nativeBridge.createEmulationTexture(
      width: (topScreenWidth * devicePixelRatio).round(),
      height: (topScreenHeight * devicePixelRatio).round(),
    );
    bottomTextureId = await _nativeBridge.createEmulationTexture(
      width: (bottomScreenWidth * devicePixelRatio).round(),
      height: (bottomScreenHeight * devicePixelRatio).round(),
      secondary: true,
    );
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
