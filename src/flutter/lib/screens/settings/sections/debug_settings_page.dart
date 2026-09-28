import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/debug_settings_provider.dart';
import '../../../data/settings/sections/debug_settings.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_group_card.dart';
import '../widgets/settings_list.dart';
import '../widgets/toggle_settings_item.dart';

class DebugSettingsPage extends ConsumerWidget {
  const DebugSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final debugSettings = ref.watch(debugSettingsProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.debug.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (Platform.isLinux && debugSettings != null)
            SettingsGroupCard(
              items: [
                ToggleSettingsItem(
                  icon: Icons.terminal,
                  title: t.settings.debug.logToConsole,
                  subtitle: t.settings.debug.logToConsoleDescription,
                  value: debugSettings.logToConsole,
                  onChanged: (value) => ref
                      .read(debugSettingsProvider.notifier)
                      .setLogToConsole(value),
                ),
              ],
            ),
          SettingsList(
            items: buildDebugSettingsItems(t),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
