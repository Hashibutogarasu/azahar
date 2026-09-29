import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/artic_base_provider.dart';
import '../../../data/settings/cia_install_provider.dart';
import '../../../data/settings/gpu_driver_provider.dart';
import '../../../data/logging_service.dart';
import '../../../data/settings/logging_provider.dart';
import '../../../i18n/translations.g.dart';
import '../../../routing/app_routes.dart';
import '../../settings/widgets/settings_group_card.dart';
import '../dialogs/artic_base_connect_dialog.dart';

class ToolsOptionsGroup extends ConsumerWidget {
  const ToolsOptionsGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    return FutureBuilder<bool>(
      future: ref.read(gpuDriverProvider).isSupported(),
      builder: (context, snapshot) {
        final supportsGpuDriverLoading = snapshot.data ?? false;
        return SettingsGroupCard(
          settingsGroupTitle: t.options.groups.tools,
          items: [
            babstrap.SettingsItem(
              icons: Icons.wifi_tethering,
              title: t.options.articBaseConnect,
              subtitle: t.options.articBaseConnectDescription,
              onTap: () =>
                  _connectArticBase(context, ref.read(articBaseProvider)),
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
              onTap: () => _shareLog(context, ref.read(loggingProvider)),
            ),
            if (supportsGpuDriverLoading)
              babstrap.SettingsItem(
                icons: Icons.memory,
                title: t.options.gpuDriverManager,
                subtitle: t.options.gpuDriverManagerDescription,
                onTap: () => const GpuDriverManagerRoute().push(context),
              ),
          ],
        );
      },
    );
  }

  Future<void> _connectArticBase(
    BuildContext context,
    ArticBaseService service,
  ) async {
    final previousAddress = await service.previousAddress();
    if (!context.mounted) return;
    final address = await ArticBaseConnectDialog.show(
      context,
      initialAddress: previousAddress ?? '',
    );
    if (address == null || address.isEmpty) return;
    await service.connect(address);
  }

  Future<void> _shareLog(BuildContext context, LoggingService service) async {
    final t = context.t;
    final found = await service.share();
    if (!found && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.options.shareLogNotFound)));
    }
  }
}
