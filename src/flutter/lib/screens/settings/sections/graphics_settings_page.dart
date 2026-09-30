import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/options/categories/renderer_options.dart';
import '../../options/option_category_page.dart';

/// The graphics settings page, defined as data by [rendererOptionsProvider].
class GraphicsSettingsPage extends StatelessWidget {
  const GraphicsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionCategoryPage(provider: rendererOptionsProvider);
  }
}
