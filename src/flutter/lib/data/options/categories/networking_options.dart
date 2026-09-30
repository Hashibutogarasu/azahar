import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/app_routes.dart';
import '../../settings/networking_settings_provider.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';

/// The Networking category: network access, real Wi-Fi scanning and the emulated network page.
final networkingOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'networking',
    titleKey: 'options.groups.networking',
    sections: [
      OptionSection(
        options: [
          BoolOption(
            titleKey: 'settings.networking.accessNetwork',
            descriptionKey: 'settings.networking.accessNetworkDescription',
            icon: Icons.wifi,
            value: CallbackOptionValue<bool>(
              onRead: (ref) =>
                  ref.watch(networkingSettingsProvider).accessNetwork,
              onWrite: (context, ref, value) => ref
                  .read(networkingSettingsProvider.notifier)
                  .setAccessNetwork(value),
            ),
          ),
          BoolOption(
            titleKey: 'settings.networking.useWireless',
            descriptionKey: 'settings.networking.useWirelessDescription',
            icon: Icons.wifi_tethering,
            value: CallbackOptionValue<bool>(
              onRead: (ref) =>
                  ref.watch(networkingSettingsProvider).useWireless,
              onWrite: (context, ref, value) => ref
                  .read(networkingSettingsProvider.notifier)
                  .setUseWireless(value),
            ),
          ),
          const NestedOption(
            titleKey: 'settings.networking.emulatedNetwork',
            descriptionKey: 'settings.networking.emulatedNetworkDescription',
            icon: Icons.router,
            destination: OptionsEmulatedNetworkSettingsRoute(),
          ),
        ],
      ),
    ],
  ),
);
