import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/accessibility_settings_provider.dart';
import '../../../i18n/translations.g.dart';
import '../../../widgets/app_toggle_switch.dart';
import '../widgets/settings_group_card.dart';

class AccessibilitySettingsPage extends ConsumerWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final accessibility = t.settings.accessibility;
    final settings = ref.watch(accessibilitySettingsProvider);
    final notifier = ref.read(accessibilitySettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(accessibility.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsGroupCard(
            items: [
              babstrap.SettingsItem(
                icons: Icons.motion_photos_off_outlined,
                title: accessibility.reduceMotion,
                subtitle: accessibility.reduceMotionDescription,
                trailing: AppToggleSwitch(
                  value: settings.reduceMotion,
                  onChanged: notifier.setReduceMotion,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
