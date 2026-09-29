import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../emulation_main.dart';
import '../../models/game.dart';

final gameProcessProvider =
    NotifierProvider.autoDispose<GameProcessNotifier, bool>(
      GameProcessNotifier.new,
    );

/// Tracks whether a game is currently running, launching it as a separate
/// process of this executable on Linux, or as Android's separate
/// `EmulationActivity` process on other platforms.
class GameProcessNotifier extends Notifier<bool> {
  bool _disposed = false;

  @override
  bool build() {
    ref.onDispose(() => _disposed = true);
    return false;
  }

  Future<void> launch(Game game) async {
    if (state) return;
    await AppServices.gameRepository.markLastPlayed(game.path);
    if (Platform.isLinux) {
      final environment = Map<String, String>.of(Platform.environment)
        ..removeWhere((key, _) => key.startsWith('FLUTTER_ENGINE_SWITCH'));
      final process = await Process.start(
        Platform.resolvedExecutable,
        [emulationArgument, game.path],
        environment: environment,
        includeParentEnvironment: false,
        mode: ProcessStartMode.inheritStdio,
      );
      state = true;
      unawaited(
        process.exitCode.then((_) {
          if (!_disposed) state = false;
        }),
      );
      return;
    }
    await AppServices.nativeBridge.launchEmulationActivity(game.path);
  }
}
