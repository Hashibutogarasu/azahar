import 'package:flutter/widgets.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

class EmulationSessionState {
  const EmulationSessionState({
    this.isLaunched = false,
    this.emulationStarted = false,
    this.isPaused = false,
    this.isAutoPaused = false,
    this.isScreensSwapped = false,
    this.isTerminating = false,
    this.isClosingWindow = false,
    this.isFinished = false,
    this.isShutdownRequested = false,
    this.topTextureId,
    this.bottomTextureId,
    this.bottomTextureSize,
    this.shaderProgress,
  });

  final bool isLaunched;
  final bool emulationStarted;
  final bool isPaused;
  final bool isAutoPaused;
  final bool isScreensSwapped;
  final bool isTerminating;
  final bool isClosingWindow;

  final bool isFinished;

  /// Whether the game asked to end, so the user has to choose to save or discard its changes.
  final bool isShutdownRequested;
  final int? topTextureId;
  final int? bottomTextureId;
  final Size? bottomTextureSize;
  final ShaderCacheProgress? shaderProgress;

  EmulationSessionState copyWith({
    bool? isLaunched,
    bool? emulationStarted,
    bool? isPaused,
    bool? isAutoPaused,
    bool? isScreensSwapped,
    bool? isTerminating,
    bool? isClosingWindow,
    bool? isFinished,
    bool? isShutdownRequested,
    int? topTextureId,
    int? bottomTextureId,
    Size? bottomTextureSize,
    ShaderCacheProgress? shaderProgress,
  }) {
    return EmulationSessionState(
      isLaunched: isLaunched ?? this.isLaunched,
      emulationStarted: emulationStarted ?? this.emulationStarted,
      isPaused: isPaused ?? this.isPaused,
      isAutoPaused: isAutoPaused ?? this.isAutoPaused,
      isScreensSwapped: isScreensSwapped ?? this.isScreensSwapped,
      isTerminating: isTerminating ?? this.isTerminating,
      isClosingWindow: isClosingWindow ?? this.isClosingWindow,
      isFinished: isFinished ?? this.isFinished,
      isShutdownRequested: isShutdownRequested ?? this.isShutdownRequested,
      topTextureId: topTextureId ?? this.topTextureId,
      bottomTextureId: bottomTextureId ?? this.bottomTextureId,
      bottomTextureSize: bottomTextureSize ?? this.bottomTextureSize,
      shaderProgress: shaderProgress ?? this.shaderProgress,
    );
  }
}
