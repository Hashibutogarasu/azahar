import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/options/categories/accessibility_page_options.dart';
import '../../../i18n/translations.g.dart';
import '../../options/widgets/option_group_card.dart';

class AccessibilitySettingsPage extends ConsumerWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(accessibilityPageOptionsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.t.settings.accessibility.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [OptionGroupCard(entries: category.entries)],
      ),
    );
  }
}
