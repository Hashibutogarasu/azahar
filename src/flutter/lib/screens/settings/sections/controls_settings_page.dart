import 'package:flutter/material.dart';

import '../../../data/options/categories/controls_settings_options.dart';
import '../../options/option_category_page.dart';

/// The gamepad settings page, defined as data by [controlsSettingsOptionsProvider].
class ControlsSettingsPage extends StatelessWidget {
  const ControlsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionCategoryPage(provider: controlsSettingsOptionsProvider);
  }
}
