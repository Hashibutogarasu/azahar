import 'package:flutter/material.dart';

import '../../../data/options/categories/media_options.dart';
import '../../options/option_category_page.dart';

/// The media settings page, defined as data by [mediaOptionsProvider].
class MediaSettingsPage extends StatelessWidget {
  const MediaSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionCategoryPage(provider: mediaOptionsProvider);
  }
}
