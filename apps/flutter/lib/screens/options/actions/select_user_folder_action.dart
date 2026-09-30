import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/user_directories_provider.dart';
import '../../setup/dialogs/citra_directory_dialog.dart';
import '../../setup/dialogs/copy_dir_progress_dialog.dart';

/// Lets the user pick the user folder and, when it changed, optionally moves the data over.
abstract final class SelectUserFolderAction {
  static Future<void> run(BuildContext context, WidgetRef ref) async {
    final service = ref.read(userDirectoriesProvider);
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
}
