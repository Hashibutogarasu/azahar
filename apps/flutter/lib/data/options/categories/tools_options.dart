import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/app_routes.dart';
import '../../../screens/options/actions/connect_artic_base_action.dart';
import '../../../screens/options/actions/share_log_action.dart';
import '../../settings/cia_install_provider.dart';
import '../../settings/gpu_driver_provider.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';

/// The Tools category: Artic Base, content installation, system files, log sharing and, where the
/// platform supports custom drivers, the GPU driver manager.
final toolsOptionsProvider = Provider<OptionCategory>((ref) {
  final supportsGpuDriverLoading =
      ref.watch(gpuDriverSupportedProvider).value ?? false;
  return OptionCategory(
    id: 'tools',
    title: (t) => t.options.groups.tools,
    sections: [
      OptionSection(
        options: [
          ActionOption(
            title: (t) => t.options.articBaseConnect,
            description: (t) => t.options.articBaseConnectDescription,
            icon: Icons.wifi_tethering,
            onTap: ConnectArticBaseAction.run,
          ),
          ActionOption(
            title: (t) => t.options.installGameContent,
            description: (t) => t.options.installGameContentDescription,
            icon: Icons.install_mobile,
            onTap: (context, ref) =>
                ref.read(ciaInstallProvider).pickAndInstall(),
          ),
          NestedOption(
            title: (t) => t.options.setupSystemFiles,
            description: (t) => t.options.setupSystemFilesDescription,
            icon: Icons.build_outlined,
            destination: const SystemFilesRoute(),
          ),
          ActionOption(
            title: (t) => t.options.shareLog,
            description: (t) => t.options.shareLogDescription,
            icon: Icons.share_outlined,
            onTap: ShareLogAction.run,
          ),
          if (supportsGpuDriverLoading)
            NestedOption(
              title: (t) => t.options.gpuDriverManager,
              description: (t) => t.options.gpuDriverManagerDescription,
              icon: Icons.memory,
              destination: const GpuDriverManagerRoute(),
            ),
        ],
      ),
    ],
  );
});
