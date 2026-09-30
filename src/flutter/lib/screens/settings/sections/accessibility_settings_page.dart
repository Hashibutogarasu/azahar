import 'package:flutter/material.dart';

import '../../../data/options/categories/accessibility_settings_options.dart';
import '../../options/option_category_page.dart';

/// The accessibility settings page, defined as data by [accessibilitySettingsOptionsProvider].
class AccessibilitySettingsPage extends StatelessWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionCategoryPage(provider: accessibilitySettingsOptionsProvider);
  }
}
