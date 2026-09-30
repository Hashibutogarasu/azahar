import 'package:flutter/material.dart';

import '../../../data/options/categories/layout_page_options.dart';
import '../../options/option_category_page.dart';

class LayoutSettingsPage extends StatelessWidget {
  const LayoutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionCategoryPage(provider: layoutPageOptionsProvider);
  }
}

class CustomLandscapeLayoutSettingsPage extends StatelessWidget {
  const CustomLandscapeLayoutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionCategoryPage(
      provider: customLandscapeLayoutPageOptionsProvider,
    );
  }
}

class CustomPortraitLayoutSettingsPage extends StatelessWidget {
  const CustomPortraitLayoutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionCategoryPage(
      provider: customPortraitLayoutPageOptionsProvider,
    );
  }
}
