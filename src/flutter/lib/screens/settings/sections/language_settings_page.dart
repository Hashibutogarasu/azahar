import 'package:flutter/material.dart';

import '../../../data/options/categories/language_options.dart';
import '../../options/option_category_page.dart';

/// The language settings page, defined as data by [languageOptionsProvider].
class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionCategoryPage(provider: languageOptionsProvider);
  }
}
