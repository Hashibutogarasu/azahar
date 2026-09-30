import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/options/categories/graphics_page_options.dart';
import '../../options/widgets/option_category_page.dart';

class GraphicsSettingsPage extends ConsumerWidget {
  const GraphicsSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OptionCategoryPage(category: ref.watch(graphicsPageOptionsProvider));
  }
}
