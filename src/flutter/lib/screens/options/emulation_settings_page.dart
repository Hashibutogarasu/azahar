import 'package:babstrap_settings_screen/babstrap_settings_screen.dart' as babstrap;
import 'package:flutter/material.dart';

import '../../i18n/translations.g.dart';
import '../../routing/app_routes.dart';
import '../settings/widgets/settings_group_card.dart';

/// The "Emulation" subpage reached from the Options page's System group. Groups the
/// General, System, Audio, Camera and Controls settings that previously lived directly on the
/// `/settings` hub.
class EmulationSettingsPage extends StatelessWidget {
  const EmulationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.options.emulation)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsGroupCard(
            items: [
              babstrap.SettingsItem(
                icons: Icons.tune,
                title: t.settings.general.title,
                onTap: () => const OptionsGeneralSettingsRoute().push(context),
              ),
              babstrap.SettingsItem(
                icons: Icons.memory,
                title: t.settings.system.title,
                onTap: () => const OptionsSystemSettingsRoute().push(context),
              ),
              babstrap.SettingsItem(
                icons: Icons.volume_up,
                title: t.settings.audio.title,
                onTap: () => const OptionsAudioSettingsRoute().push(context),
              ),
              babstrap.SettingsItem(
                icons: Icons.camera_alt,
                title: t.settings.camera.title,
                onTap: () => const OptionsCameraSettingsRoute().push(context),
              ),
              babstrap.SettingsItem(
                icons: Icons.sports_esports,
                title: t.settings.gamepad.title,
                onTap: () => const OptionsControlsSettingsRoute().push(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
