import 'package:flutter/material.dart';

import '../../../app_services.dart';
import '../../../i18n/translations.g.dart';
import '../../../models/game.dart';
import '../../../models/game_folder_status.dart';
import '../../../models/game_uninstall_target.dart';

/// Mirrors the Compose client's `UninstallMenuButton`: a tonal delete icon button that opens a
/// dropdown listing [game]'s content, updates and DLC, deleting whichever the user picks.
class UninstallMenuButton extends StatelessWidget {
  const UninstallMenuButton({
    super.key,
    required this.game,
    required this.status,
    required this.onUninstalled,
  });

  final Game game;
  final GameFolderStatus status;
  final VoidCallback onUninstalled;

  Future<void> _delete(GameUninstallTarget target) async {
    final deleted = await AppServices.nativeBridge.deleteGameFolder(game, target);
    if (deleted) {
      onUninstalled();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colorScheme = Theme.of(context).colorScheme;
    final entries = <(GameUninstallTarget, String, bool)>[
      (GameUninstallTarget.cia, t.games.uninstallCia, status.app),
      (GameUninstallTarget.updates, t.games.uninstallUpdates, status.updates),
      (GameUninstallTarget.dlc, t.games.uninstallDlc, status.dlc),
    ];
    return PopupMenuButton<GameUninstallTarget>(
      tooltip: t.games.delete,
      onSelected: _delete,
      itemBuilder: (context) => [
        for (final (target, label, enabled) in entries)
          PopupMenuItem<GameUninstallTarget>(value: target, enabled: enabled, child: Text(label)),
      ],
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: colorScheme.secondaryContainer, shape: BoxShape.circle),
        child: Icon(Icons.delete_outline, color: colorScheme.onSecondaryContainer),
      ),
    );
  }
}
