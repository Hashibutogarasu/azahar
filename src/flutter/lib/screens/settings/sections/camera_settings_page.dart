import 'package:flutter/material.dart';

import '../../../data/settings/sections/camera_settings.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_list.dart';

class CameraSettingsPage extends StatelessWidget {
  const CameraSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.camera.title)),
      body: SettingsList(items: buildCameraSettingsItems(t)),
    );
  }
}
