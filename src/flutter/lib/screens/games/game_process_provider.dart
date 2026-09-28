import 'dart:async';
import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../models/game.dart';

final gameProcessProvider =
    NotifierProvider.autoDispose<GameProcessNotifier, bool>(GameProcessNotifier.new);

/// Tracks whether a game is currently running, launching it as a separate
/// window (via `desktop_multi_window`) on Linux, or as Android's separate
/// `EmulationActivity` process on other platforms.
class GameProcessNotifier extends Notifier<bool> {
  StreamSubscription<void>? _windowsChangedSubscription;
  String? _windowId;

  @override
  bool build() {
    if (Platform.isLinux) {
      _windowsChangedSubscription = onWindowsChanged.listen((_) => _checkWindow());
      ref.onDispose(() => _windowsChangedSubscription?.cancel());
    }
    return false;
  }

  Future<void> _checkWindow() async {
    final windowId = _windowId;
    if (windowId == null) return;
    final windows = await WindowController.getAll();
    if (windows.any((window) => window.windowId == windowId)) return;
    _windowId = null;
    state = false;
  }

  Future<void> launch(Game game) async {
    if (state) return;
    await AppServices.gameRepository.markLastPlayed(game.path);
    if (Platform.isLinux) {
      final controller = await WindowController.create(
        WindowConfiguration(arguments: game.path, hiddenAtLaunch: false),
      );
      _windowId = controller.windowId;
      state = true;
      await controller.show();
      return;
    }
    await AppServices.nativeBridge.launchEmulationActivity(game.path);
  }
}
