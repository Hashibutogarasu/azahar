import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/settings/artic_base_provider.dart';
import '../../data/settings/cia_install_provider.dart';
import '../../data/settings/gpu_driver_provider.dart';
import '../../data/settings/share_log_provider.dart';
import '../../data/settings/user_directories_provider.dart';
import '../../i18n/translations.g.dart';
import '../../routing/app_routes.dart';
import '../settings/settings_routes.dart';
import '../setup/dialogs/citra_directory_dialog.dart';
import '../setup/dialogs/copy_dir_progress_dialog.dart';
import 'dialogs/artic_base_connect_dialog.dart';

/// The Options tab's grid of app-level settings and shortcuts, mirroring the original app's
/// `HomeSettingsScreen`.
class OptionsPage extends ConsumerWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: ref.read(gpuDriverProvider).isSupported(),
          builder: (context, snapshot) {
            final supportsGpuDriverLoading = snapshot.data ?? false;
            return GridView(
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
                  icon: Icons.install_mobile,
                  title: t.options.installGameContent,
                  description: t.options.installGameContentDescription,
                  onTap: () => ref.read(ciaInstallProvider).pickAndInstall(),
                ),
                _OptionCard(
                  icon: Icons.build_outlined,
                  title: t.options.setupSystemFiles,
                  description: t.options.setupSystemFilesDescription,
                  onTap: () => const SystemFilesRoute().push(context),
                ),
                _OptionCard(
                  icon: Icons.info_outline,
                  title: t.options.about,
                  description: t.options.aboutDescription,
                  onTap: () => const AboutRoute().push(context),
                ),
                _OptionCard(
                  icon: Icons.wifi_tethering,
                  title: t.options.articBaseConnect,
                  description: t.options.articBaseConnectDescription,
                  onTap: () => _connectArticBase(context, ref.read(articBaseProvider)),
                ),
                _OptionCard(
                  icon: Icons.share_outlined,
                  title: t.options.shareLog,
                  description: t.options.shareLogDescription,
                  onTap: () => _shareLog(context, ref.read(shareLogProvider)),
                ),
                if (supportsGpuDriverLoading)
                  _OptionCard(
                    icon: Icons.memory,
                    title: t.options.gpuDriverManager,
                    description: t.options.gpuDriverManagerDescription,
                    onTap: () => const GpuDriverManagerRoute().push(context),
                  ),
              ],
            );
          },
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

  Future<void> _connectArticBase(BuildContext context, ArticBaseService service) async {
    final previousAddress = await service.previousAddress();
    if (!context.mounted) return;
    final address = await ArticBaseConnectDialog.show(
      context,
      initialAddress: previousAddress ?? '',
    );
    if (address == null || address.isEmpty) return;
    await service.connect(address);
  }

  Future<void> _shareLog(BuildContext context, ShareLogService service) async {
    final t = context.t;
    final found = await service.share();
    if (!found && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.options.shareLogNotFound)));
    }
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
