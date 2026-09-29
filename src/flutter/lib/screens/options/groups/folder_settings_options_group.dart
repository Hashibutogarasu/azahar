import 'dart:async';

import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/user_directories_provider.dart';
import '../../../i18n/translations.g.dart';
import '../../settings/widgets/settings_group_card.dart';
import '../../setup/dialogs/citra_directory_dialog.dart';
import '../../setup/dialogs/copy_dir_progress_dialog.dart';

class FolderSettingsOptionsGroup extends ConsumerWidget {
  const FolderSettingsOptionsGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    return SettingsGroupCard(
      settingsGroupTitle: t.options.groups.folderSettings,
      items: [
        babstrap.SettingsItem(
          icons: Icons.folder_outlined,
          title: t.options.selectUserFolder,
          subtitle: t.options.selectUserFolderDescription,
          onTap: () =>
              _selectUserFolder(context, ref.read(userDirectoriesProvider)),
        ),
        babstrap.SettingsItem(
          icons: Icons.videogame_asset_outlined,
          title: t.options.selectGamesFolder,
          subtitle: t.options.selectGamesFolderDescription,
          onTap: () =>
              _selectGamesFolder(context, ref.read(userDirectoriesProvider)),
        ),
      ],
    );
  }

  Future<void> _selectUserFolder(
    BuildContext context,
    UserDirectoriesService service,
  ) async {
    final previousUri = await service.previousUserDirectory();
    final pickedUri = await service.pickUserDirectory();
    if (pickedUri == null || !context.mounted) return;

    final moveData = await CitraDirectoryDialog.show(
      context,
      path: pickedUri,
      showMoveDataCheckbox: previousUri != null && previousUri != pickedUri,
    );
    if (moveData == null) return;

    final confirmed = service.confirmUserDirectory(
      uri: pickedUri,
      previousUri: previousUri,
      moveData: moveData,
    );
    if (!moveData) {
      await confirmed;
      return;
    }

    if (!context.mounted) return;
    unawaited(
      CopyDirProgressDialog.show(
        context,
        progressStream: service.copyDirProgress(),
      ),
    );
    await confirmed;
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future<void> _selectGamesFolder(
    BuildContext context,
    UserDirectoriesService service,
  ) async {
    final pickedUri = await service.pickGamesDirectory();
    if (pickedUri == null) return;
    await service.confirmGamesDirectory(pickedUri);
  }
}
