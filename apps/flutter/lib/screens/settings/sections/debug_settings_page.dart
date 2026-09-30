import 'package:flutter/material.dart';

import '../../../data/options/categories/debug_options.dart';
import '../../options/option_category_page.dart';

/// The debug settings page, defined as data by [debugOptionsProvider].
class DebugSettingsPage extends StatelessWidget {
  const DebugSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionCategoryPage(provider: debugOptionsProvider);
  }
}
