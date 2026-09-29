import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/accessibility_settings_provider.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_group_card.dart';
import '../widgets/toggle_settings_item.dart';

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
              ToggleSettingsItem(
                icon: Icons.motion_photos_off_outlined,
                title: accessibility.reduceMotion,
                subtitle: accessibility.reduceMotionDescription,
                value: settings.reduceMotion,
                onChanged: notifier.setReduceMotion,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
