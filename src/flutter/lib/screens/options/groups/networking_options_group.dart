import 'package:babstrap_settings_screen/babstrap_settings_screen.dart' as babstrap;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/networking_settings_provider.dart';
import '../../../i18n/translations.g.dart';
import '../../settings/widgets/settings_group_card.dart';

class NetworkingOptionsGroup extends ConsumerWidget {
  const NetworkingOptionsGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final state = ref.watch(networkingSettingsProvider);
    final notifier = ref.read(networkingSettingsProvider.notifier);
    return SettingsGroupCard(
      settingsGroupTitle: t.options.groups.networking,
      items: [
        babstrap.SettingsItem(
          icons: Icons.wifi,
          title: t.settings.networking.accessNetwork,
          subtitle: t.settings.networking.accessNetworkDescription,
          trailing: Switch(value: state.accessNetwork, onChanged: notifier.setAccessNetwork),
        ),
        babstrap.SettingsItem(
          icons: Icons.wifi_tethering,
          title: t.settings.networking.useWireless,
          subtitle: t.settings.networking.useWirelessDescription,
          trailing: Switch(value: state.useWireless, onChanged: notifier.setUseWireless),
        ),
      ],
    );
  }
}
