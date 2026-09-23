import 'package:flutter/widgets.dart';

import '../../models/shader_cache_progress.dart';

class EmulationSessionState {
  const EmulationSessionState({
    this.isLaunched = false,
    this.emulationStarted = false,
    this.isPaused = false,
    this.isScreensSwapped = false,
    this.topTextureId,
    this.bottomTextureId,
    this.bottomTextureSize,
    this.shaderProgress,
  });

  final bool isLaunched;
  final bool emulationStarted;
  final bool isPaused;
  final bool isScreensSwapped;
  final int? topTextureId;
  final int? bottomTextureId;
  final Size? bottomTextureSize;
  final ShaderCacheProgress? shaderProgress;

  EmulationSessionState copyWith({
    bool? isLaunched,
    bool? emulationStarted,
    bool? isPaused,
    bool? isScreensSwapped,
    int? topTextureId,
    int? bottomTextureId,
    Size? bottomTextureSize,
    ShaderCacheProgress? shaderProgress,
  }) {
    return EmulationSessionState(
      isLaunched: isLaunched ?? this.isLaunched,
      emulationStarted: emulationStarted ?? this.emulationStarted,
      isPaused: isPaused ?? this.isPaused,
      isScreensSwapped: isScreensSwapped ?? this.isScreensSwapped,
      topTextureId: topTextureId ?? this.topTextureId,
      bottomTextureId: bottomTextureId ?? this.bottomTextureId,
      bottomTextureSize: bottomTextureSize ?? this.bottomTextureSize,
      shaderProgress: shaderProgress ?? this.shaderProgress,
    );
  }
}
