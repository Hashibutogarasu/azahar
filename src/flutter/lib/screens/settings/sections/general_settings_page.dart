import 'package:flutter/material.dart';

import '../../../data/options/categories/profile_options.dart';
import '../../options/option_category_page.dart';

/// The profile settings page, defined as data by [profileOptionsProvider].
class GeneralSettingsPage extends StatelessWidget {
  const GeneralSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionCategoryPage(provider: profileOptionsProvider);
  }
}
