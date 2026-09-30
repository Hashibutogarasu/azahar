import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/options/categories/controls_page_options.dart';
import '../../options/widgets/option_category_page.dart';

class ControlsSettingsPage extends ConsumerWidget {
  const ControlsSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OptionCategoryPage(category: ref.watch(controlsPageOptionsProvider));
  }
}
