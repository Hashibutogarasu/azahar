import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/user_directories_provider.dart';

/// Lets the user pick the folder the games are scanned from.
abstract final class SelectGamesFolderAction {
  static Future<void> run(BuildContext context, WidgetRef ref) async {
    final service = ref.read(userDirectoriesProvider);
    final pickedUri = await service.pickGamesDirectory();
    if (pickedUri == null) return;
    await service.confirmGamesDirectory(pickedUri);
  }
}
