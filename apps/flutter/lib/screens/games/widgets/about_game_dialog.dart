import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';

import 'about_game_content.dart';

/// The information dialog of a game, shown on desktop platforms instead of the bottom sheet.
class AboutGameDialog extends StatelessWidget {
  const AboutGameDialog({
    super.key,
    required this.game,
    required this.onPlay,
    required this.onUninstalled,
  });

  final Game game;
  final VoidCallback onPlay;
  final VoidCallback onUninstalled;

  static Future<void> show(
    BuildContext context, {
    required Game game,
    required VoidCallback onPlay,
    required VoidCallback onUninstalled,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => AboutGameDialog(
        game: game,
        onPlay: onPlay,
        onUninstalled: onUninstalled,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AboutGameContent(
            game: game,
            onPlay: onPlay,
            onUninstalled: onUninstalled,
          ),
        ),
      ),
    );
  }
}
