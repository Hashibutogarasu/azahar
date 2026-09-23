import 'package:flutter/material.dart';

import '../../../data/settings/sections/graphics_settings.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_list.dart';

class GraphicsSettingsPage extends StatelessWidget {
  const GraphicsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.graphics.title)),
      body: SettingsList(items: buildGraphicsSettingsItems(t)),
    );
  }
}
