import 'package:flutter/material.dart';

import '../../../data/options/categories/theme_options.dart';
import '../../options/option_category_page.dart';

/// The theme and color settings page, defined as data by [themeOptionsProvider].
class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionCategoryPage(provider: themeOptionsProvider);
  }
}
