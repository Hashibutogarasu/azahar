import 'package:flutter/material.dart';

import '../../../data/options/categories/advanced_options.dart';
import '../../options/option_category_page.dart';

/// The advanced settings page, defined as data by [advancedOptionsProvider].
class AdvancedSettingsPage extends StatelessWidget {
  const AdvancedSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionCategoryPage(provider: advancedOptionsProvider);
  }
}
