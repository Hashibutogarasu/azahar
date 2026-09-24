import 'package:flutter/material.dart';

import '../../../data/settings/sections/media_settings.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_list.dart';

class MediaSettingsPage extends StatelessWidget {
  const MediaSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.media.title)),
      body: SettingsList(items: buildMediaSettingsItems(t)),
    );
  }
}
