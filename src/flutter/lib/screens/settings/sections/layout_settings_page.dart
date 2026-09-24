import 'package:flutter/material.dart';

import '../../../data/settings/sections/layout_settings.dart';
import '../../../i18n/translations.g.dart';
import '../../options/options_routes.dart';
import '../widgets/settings_list.dart';

class LayoutSettingsPage extends StatelessWidget {
  const LayoutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.layout.title)),
      body: SettingsList(
        items: buildLayoutSettingsItems(
          t,
          onOpenCustomLandscapeLayout: (context) =>
              const OptionsCustomLandscapeLayoutSettingsRoute().push(context),
          onOpenCustomPortraitLayout: (context) =>
              const OptionsCustomPortraitLayoutSettingsRoute().push(context),
        ),
      ),
    );
  }
}

class CustomLandscapeLayoutSettingsPage extends StatelessWidget {
  const CustomLandscapeLayoutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.layout.customLandscapeLayout)),
      body: SettingsList(items: buildCustomLandscapeLayoutItems(t)),
    );
  }
}

class CustomPortraitLayoutSettingsPage extends StatelessWidget {
  const CustomPortraitLayoutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.layout.customPortraitLayout)),
      body: SettingsList(items: buildCustomPortraitLayoutItems(t)),
    );
  }
}
