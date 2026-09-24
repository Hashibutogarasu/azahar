import 'package:flutter/material.dart';

import '../../../app_services.dart';
import '../../../i18n/translations.g.dart';
import '../../../models/game.dart';
import '../../../models/game_folder_kind.dart';
import '../../../models/game_folder_status.dart';

/// Mirrors the Compose client's `OpenFolderMenuButton`: a tonal folder icon button that opens a
/// dropdown of [game]'s well-known folders, each opened in an external file manager when tapped.
class OpenFolderMenuButton extends StatelessWidget {
  const OpenFolderMenuButton({super.key, required this.game, required this.status});

  final Game game;
  final GameFolderStatus status;

  void _open(GameFolderKind folder) {
    AppServices.nativeBridge.openGameFolder(game, folder);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colorScheme = Theme.of(context).colorScheme;
    final entries = <(GameFolderKind, String, bool)>[
      (GameFolderKind.app, t.games.openApp, status.app),
      (GameFolderKind.save, t.games.openSaveDir, status.save),
      (GameFolderKind.updates, t.games.openUpdates, status.updates),
      (GameFolderKind.dlc, t.games.openDlc, status.dlc),
      (GameFolderKind.extra, t.games.openExtra, status.extra),
      (GameFolderKind.textures, t.games.openTextures, status.textures),
      (GameFolderKind.mods, t.games.openMods, status.mods),
    ];
    return PopupMenuButton<GameFolderKind>(
      tooltip: t.games.openFolder,
      onSelected: _open,
      itemBuilder: (context) => [
        for (final (folder, label, enabled) in entries)
          PopupMenuItem<GameFolderKind>(value: folder, enabled: enabled, child: Text(label)),
      ],
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: colorScheme.secondaryContainer, shape: BoxShape.circle),
        child: Icon(Icons.folder_open, color: colorScheme.onSecondaryContainer),
      ),
    );
  }
}
