import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../models/shader_cache_progress.dart';
import '../../native/native_bridge.dart';
import 'emulation_screens_layout.dart';

class EmulationViewModel extends ChangeNotifier {
  EmulationViewModel(this._nativeBridge);

  final NativeBridge _nativeBridge;

  int? topTextureId;
  int? bottomTextureId;
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
    bottomTextureId = await _nativeBridge.createEmulationTexture(
      width: (layout.bottomScreen.width * devicePixelRatio).round(),
      height: (layout.bottomScreen.height * devicePixelRatio).round(),
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
