import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/options/categories/layout_page_options.dart';
import '../../options/widgets/option_category_page.dart';

class LayoutSettingsPage extends ConsumerWidget {
  const LayoutSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OptionCategoryPage(category: ref.watch(layoutPageOptionsProvider));
  }
}

class CustomLandscapeLayoutSettingsPage extends ConsumerWidget {
  const CustomLandscapeLayoutSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OptionCategoryPage(
      category: ref.watch(customLandscapeLayoutPageOptionsProvider),
    );
  }
}

class CustomPortraitLayoutSettingsPage extends ConsumerWidget {
  const CustomPortraitLayoutSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OptionCategoryPage(
      category: ref.watch(customPortraitLayoutPageOptionsProvider),
    );
  }
}
