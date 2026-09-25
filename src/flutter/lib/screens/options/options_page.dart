import 'dart:async';

import 'package:babstrap_settings_screen/babstrap_settings_screen.dart' as babstrap;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/settings/artic_base_provider.dart';
import '../../data/settings/cia_install_provider.dart';
import '../../data/settings/gpu_driver_provider.dart';
import '../../data/settings/options_settings_provider.dart';
import '../../data/settings/settings_load_provider.dart';
import '../../data/settings/share_log_provider.dart';
import '../../data/settings/user_directories_provider.dart';
import '../../i18n/translations.g.dart';
import '../../routing/app_routes.dart';
import '../setup/dialogs/citra_directory_dialog.dart';
import '../setup/dialogs/copy_dir_progress_dialog.dart';
import '../settings/widgets/settings_group_card.dart';
import 'dialogs/artic_base_connect_dialog.dart';

/// The Options tab: a grouped settings screen built on `babstrap_settings_screen`, grouping
/// settings into General/System/Graphics/Tools/Folder settings/Other sections.
class OptionsPage extends ConsumerWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    ref.watch(settingsLoadProvider);
    final settings = ref.read(optionsSettingsProvider);

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: ref.read(gpuDriverProvider).isSupported(),
          builder: (context, snapshot) {
            final supportsGpuDriverLoading = snapshot.data ?? false;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SettingsGroupCard(
                  settingsGroupTitle: t.options.group.general,
                  items: [
                    babstrap.SettingsItem(
                      icons: Icons.account_circle_outlined,
                      title: t.options.general,
                      subtitle: t.options.generalDescription,
                      onTap: () => const OptionsGeneralSettingsRoute().push(context),
                    ),
                    babstrap.SettingsItem(
                      icons: Icons.language,
                      title: t.settings.language.title,
                      onTap: () => const OptionsLanguageSettingsRoute().push(context),
                    ),
                    babstrap.SettingsItem(
                      icons: Icons.palette_outlined,
                      title: t.options.themeAndColor,
                      subtitle: t.options.themeAndColorDescription,
                      onTap: () => const OptionsThemeSettingsRoute().push(context),
                    ),
                    babstrap.SettingsItem(
                      icons: Icons.music_note_outlined,
                      title: t.options.media,
                      subtitle: t.options.mediaDescription,
                      onTap: () => const OptionsMediaSettingsRoute().push(context),
                    ),
                  ],
                ),
                SettingsGroupCard(
                  settingsGroupTitle: t.options.group.system,
                  items: [
                    babstrap.SettingsItem(
                      icons: Icons.memory,
                      title: t.options.emulation,
                      subtitle: t.options.emulationDescription,
                      onTap: () => const OptionsEmulationSettingsRoute().push(context),
                    ),
                    babstrap.SettingsItem(
                      icons: Icons.settings_outlined,
                      title: t.settings.system.title,
                      onTap: () => const OptionsSystemSettingsRoute().push(context),
                    ),
                  ],
                ),
                SettingsGroupCard(
                  settingsGroupTitle: t.options.group.graphics,
                  items: [
                    babstrap.SettingsItem(
                      icons: Icons.monitor,
                      title: t.settings.graphics.title,
                      onTap: () => const OptionsGraphicsSettingsRoute().push(context),
                    ),
                    babstrap.SettingsItem(
                      icons: Icons.fit_screen,
                      title: t.settings.layout.title,
                      onTap: () => const OptionsLayoutSettingsRoute().push(context),
                    ),
                    babstrap.SettingsItem(
                      icons: Icons.camera_alt,
                      title: t.settings.camera.title,
                      onTap: () => const OptionsCameraSettingsRoute().push(context),
                    ),
                  ],
                ),
                SettingsGroupCard(
                  settingsGroupTitle: t.options.group.networking,
                  items: [
                    babstrap.SettingsItem(
                      icons: Icons.wifi,
                      title: t.options.networking,
                      subtitle: t.options.networkingDescription,
                      onTap: () => const OptionsNetworkingSettingsRoute().push(context),
                    ),
                  ],
                ),
                SettingsGroupCard(
                  settingsGroupTitle: t.options.group.controls,
                  items: [
                    babstrap.SettingsItem(
                      icons: Icons.sports_esports,
                      title: t.settings.gamepad.title,
                      onTap: () => const OptionsControlsSettingsRoute().push(context),
                    ),
                  ],
                ),
                SettingsGroupCard(
                  settingsGroupTitle: t.options.group.tools,
                  items: [
                    babstrap.SettingsItem(
                      icons: Icons.wifi_tethering,
                      title: t.options.articBaseConnect,
                      subtitle: t.options.articBaseConnectDescription,
                      onTap: () => _connectArticBase(context, ref.read(articBaseProvider)),
                    ),
                    babstrap.SettingsItem(
                      icons: Icons.install_mobile,
                      title: t.options.installGameContent,
                      subtitle: t.options.installGameContentDescription,
                      onTap: () => ref.read(ciaInstallProvider).pickAndInstall(),
                    ),
                    babstrap.SettingsItem(
                      icons: Icons.build_outlined,
                      title: t.options.setupSystemFiles,
                      subtitle: t.options.setupSystemFilesDescription,
                      onTap: () => const SystemFilesRoute().push(context),
                    ),
                    babstrap.SettingsItem(
                      icons: Icons.share_outlined,
                      title: t.options.shareLog,
                      subtitle: t.options.shareLogDescription,
                      onTap: () => _shareLog(context, ref.read(shareLogProvider)),
                    ),
                    if (supportsGpuDriverLoading)
                      babstrap.SettingsItem(
                        icons: Icons.memory,
                        title: t.options.gpuDriverManager,
                        subtitle: t.options.gpuDriverManagerDescription,
                        onTap: () => const GpuDriverManagerRoute().push(context),
                      ),
                  ],
                ),
                SettingsGroupCard(
                  settingsGroupTitle: t.options.group.folderSettings,
                  items: [
                    babstrap.SettingsItem(
                      icons: Icons.folder_outlined,
                      title: t.options.selectUserFolder,
                      subtitle: t.options.selectUserFolderDescription,
                      onTap: () => _selectUserFolder(context, ref.read(userDirectoriesProvider)),
                    ),
                    babstrap.SettingsItem(
                      icons: Icons.videogame_asset_outlined,
                      title: t.options.selectGamesFolder,
                      subtitle: t.options.selectGamesFolderDescription,
                      onTap: () => _selectGamesFolder(context, ref.read(userDirectoriesProvider)),
                    ),
                  ],
                ),
                SettingsGroupCard(
                  settingsGroupTitle: t.options.group.other,
                  items: [
                    babstrap.SettingsItem(
                      icons: Icons.history_toggle_off,
                      title: t.options.useLegacySettingsUI,
                      subtitle: t.options.useLegacySettingsUIDescription,
                      trailing: Switch(
                        value: settings.useLegacySettingsUI,
                        onChanged: (value) => _confirmLegacyToggle(context, ref, t, value),
                      ),
                    ),
                    babstrap.SettingsItem(
                      icons: Icons.code,
                      title: t.settings.debug.title,
                      onTap: () => const OptionsDebugSettingsRoute().push(context),
                    ),
                    babstrap.SettingsItem(
                      icons: Icons.info_outline,
                      title: t.options.about,
                      subtitle: t.options.aboutDescription,
                      onTap: () => const AboutRoute().push(context),
                    ),
                    babstrap.SettingsItem(
                      icons: Icons.restore,
                      title: t.settings.resetToDefault,
                      titleStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      iconStyle: babstrap.IconStyle(
                        iconsColor: Theme.of(context).colorScheme.error,
                        withBackground: false,
                      ),
                      trailing: const SizedBox.shrink(),
                      onTap: () => _confirmReset(context, ref, t),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmLegacyToggle(
    BuildContext context,
    WidgetRef ref,
    Translations t,
    bool value,
  ) async {
    final dialog = t.options.useLegacySettingsUIDialog;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(dialog.title),
          content: Text(dialog.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(dialog.confirm),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(optionsSettingsProvider).setUseLegacySettingsUI(value);
    if (context.mounted) {
      context.go(OptionsRoute(isLegacy: value).location);
    }
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref, Translations t) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.settings.resetToDefaultDialog.title),
          content: Text(t.settings.resetToDefaultDialog.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(t.settings.resetToDefaultDialog.confirm),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;
    await ref.read(optionsSettingsProvider).resetAll();
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
