import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../emulation/emulation_page.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

final gameProcessProvider =
    NotifierProvider.autoDispose<GameProcessNotifier, bool>(
      GameProcessNotifier.new,
    );

/// Tracks whether a game is currently running.
///
/// The game runs in this process: the emulation screen is pushed onto the navigator and the
/// session is released when the screen is left, so another game can be started afterwards.
class GameProcessNotifier extends Notifier<bool> {
  bool _disposed = false;

  @override
  bool build() {
    ref.onDispose(() => _disposed = true);
    return false;
  }

  /// Starts the game at [path], which is [game] when it is a listed game.
  Future<void> launch(BuildContext context, {required String path, Game? game}) async {
    if (state) return;
    final navigator = Navigator.of(context, rootNavigator: true);
    state = true;
    try {
      if (game != null) {
        await AppServices.gameRepository.markLastPlayed(game.path);
      }
      await navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => EmulationPage(gamePath: path, game: game),
        ),
      );
    } finally {
      if (!_disposed) state = false;
    }
  }
}
