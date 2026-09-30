import 'package:flutter/material.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../../app_services.dart';
import '../../../i18n/translations.g.dart';
import '../../../widgets/long_press_menu_sheet.dart';
import '../../setup/dialogs/message_dialog.dart';
import 'create_shortcut_dialog.dart';
import 'delete_shader_cache_dialog.dart';
import 'game_icon.dart';
import 'game_regions_translator.dart';
import 'open_folder_menu_button.dart';
import 'uninstall_menu_button.dart';

/// Mirrors the Compose client's `AboutGameBottomSheet`: shown on a long press of a game card,
/// exposing Play, Open Folder, Delete, Create Shortcut, Cheats, Compress and Delete Shader Cache.
class AboutGameBottomSheet extends StatefulWidget {
  const AboutGameBottomSheet({
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
    return LongPressMenuSheet.show(
      context,
      builder: (_) => AboutGameBottomSheet(
        game: game,
        onPlay: onPlay,
        onUninstalled: onUninstalled,
      ),
    );
  }

  @override
  State<AboutGameBottomSheet> createState() => _AboutGameBottomSheetState();
}

class _AboutGameBottomSheetState extends State<AboutGameBottomSheet> {
  static const _noFolders = GameFolderStatus(
    app: false,
    save: false,
    updates: false,
    dlc: false,
    extra: false,
    textures: false,
    mods: false,
  );

  late final Future<GameFolderStatus> _folderStatus;

  @override
  void initState() {
    super.initState();
    _folderStatus = widget.game.isInstalled
        ? AppServices.nativeBridge.getGameFolderStatus(widget.game)
        : Future.value(_noFolders);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final theme = Theme.of(context);
    final game = widget.game;
    return LongPressMenuSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: GameIcon(iconPath: game.iconPath),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(game.company, style: theme.textTheme.bodyMedium),
                    Text(
                      translateGameRegions(t, game.regions),
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      t.games.titleIdLabel(
                        id: game.titleId
                            .toRadixString(16)
                            .toUpperCase()
                            .padLeft(16, '0'),
                      ),
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      t.games.fileLabel(name: game.filename),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<GameFolderStatus>(
            future: _folderStatus,
            builder: (context, snapshot) {
              final status = snapshot.data;
              return Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onPlay();
                      },
                      child: Text(t.games.play),
                    ),
                  ),
                  if (game.isInstalled && status != null) ...[
                    const SizedBox(width: 8),
                    OpenFolderMenuButton(game: game, status: status),
                    const SizedBox(width: 8),
                    UninstallMenuButton(
                      game: game,
                      status: status,
                      onUninstalled: () => Navigator.of(context).pop(),
                    ),
                  ],
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: t.games.shortcut,
                    onPressed: () => CreateShortcutDialog.show(context, game),
                    icon: const Icon(Icons.add_to_home_screen),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FilledButton.tonal(
                onPressed: () => MessageDialog.show(
                  context,
                  title: t.games.cheats,
                  description: t.games.cheatsUnavailable,
                ),
                child: Text(t.games.cheats),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: null,
                child: Text(t.games.compress),
              ),
            ],
          ),
          if (game.isInstalled) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                FilledButton.tonal(
                  onPressed: () => DeleteShaderCacheDialog.show(context, game),
                  child: Text(t.games.deleteShaderCache),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
