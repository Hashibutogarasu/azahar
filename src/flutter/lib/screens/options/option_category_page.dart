import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/options/option_category.dart';
import '../../i18n/translations.g.dart';
import 'widgets/option_group_card.dart';

/// A page that shows the items of one [OptionCategory] provided by [provider], one card per
/// section in the order they are defined. The category title is the page title, and a section
/// without a title of its own gets a card without a heading.
class OptionCategoryPage extends ConsumerWidget {
  const OptionCategoryPage({super.key, required this.provider});

  final Provider<OptionCategory> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final category = ref.watch(provider);
    return Scaffold(
      appBar: AppBar(title: Text(category.title(t))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final section in category.sections)
            OptionGroupCard(
              title: section.title?.call(t),
              entries: [
                for (final entry in category.entries)
                  if (identical(entry.section, section)) entry,
              ],
            ),
        ],
      ),
    );
  }
}
