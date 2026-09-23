import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/settings/user_directories_provider.dart';
import '../../i18n/translations.g.dart';
import '../../routing/app_routes.dart';
import '../settings/settings_routes.dart';
import '../setup/dialogs/citra_directory_dialog.dart';
import '../setup/dialogs/copy_dir_progress_dialog.dart';

/// The Options tab's grid of app-level settings and shortcuts, mirroring the original app's
/// `HomeSettingsScreen`.
class OptionsPage extends ConsumerWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    return Scaffold(
      body: SafeArea(
        child: GridView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: 88,
          ),
          children: [
            _OptionCard(
              icon: Icons.settings_outlined,
              title: t.options.emulatorSettings,
              description: t.options.emulatorSettingsDescription,
              onTap: () => const SettingsMenuRoute().push(context),
            ),
            _OptionCard(
              icon: Icons.palette_outlined,
              title: t.options.themeAndColor,
              description: t.options.themeAndColorDescription,
              onTap: () => const ThemeSettingsRoute().push(context),
            ),
            _OptionCard(
              icon: Icons.folder_outlined,
              title: t.options.selectUserFolder,
              description: t.options.selectUserFolderDescription,
              onTap: () => _selectUserFolder(context, ref.read(userDirectoriesProvider)),
            ),
            _OptionCard(
              icon: Icons.videogame_asset_outlined,
              title: t.options.selectGamesFolder,
              description: t.options.selectGamesFolderDescription,
              onTap: () => _selectGamesFolder(context, ref.read(userDirectoriesProvider)),
            ),
            _OptionCard(
              icon: Icons.info_outline,
              title: t.options.about,
              description: t.options.aboutDescription,
              onTap: () => const AboutRoute().push(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectUserFolder(BuildContext context, UserDirectoriesService service) async {
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
      CopyDirProgressDialog.show(context, progressStream: service.copyDirProgress()),
    );
    await confirmed;
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future<void> _selectGamesFolder(BuildContext context, UserDirectoriesService service) async {
    final pickedUri = await service.pickGamesDirectory();
    if (pickedUri == null) return;
    await service.confirmGamesDirectory(pickedUri);
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    Text(description, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
