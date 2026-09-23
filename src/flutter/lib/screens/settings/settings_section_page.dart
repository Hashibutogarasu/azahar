import 'package:flutter/material.dart';

import '../../data/settings/sections/general_settings.dart';
import '../../data/settings/settings_item.dart';
import '../../i18n/translations.g.dart';
import 'widgets/settings_list.dart';

const String coreSectionTag = 'Core';

/// Hosts one settings section, mirroring the original app's `SettingsSectionScreen`. [menuTag]
/// selects which section's items to build and display.
class SettingsSectionPage extends StatelessWidget {
  const SettingsSectionPage({super.key, required this.menuTag});

  final String menuTag;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final (String title, List<SettingsItem> items) = switch (menuTag) {
      coreSectionTag => (t.settings.general.title, buildGeneralSettingsItems(t)),
      _ => (menuTag, const []),
    };
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SettingsList(items: items),
    );
  }
}
