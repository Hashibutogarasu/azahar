import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/options/option_category.dart';
import '../../../data/options/option_section.dart';
import '../../../i18n/translations.g.dart';
import 'option_group_card.dart';

/// Shows an [OptionCategory] as one [OptionGroupCard] per section, titled with the section's title.
/// A section without a title takes the category's title instead when [fallbackToCategoryTitle] is
/// set, and is left untitled otherwise. A section is shown disabled while its
/// [OptionSection.disabledWhen] is true.
class OptionCategoryCards extends ConsumerWidget {
  const OptionCategoryCards({
    super.key,
    required this.category,
    this.fallbackToCategoryTitle = false,
  });

  final OptionCategory category;
  final bool fallbackToCategoryTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final section in category.sections)
          OptionGroupCard(
            enabled: switch (section.disabledWhen) {
              final disabledWhen? => !ref.watch(disabledWhen),
              null => true,
            },
            title: switch (section.title) {
              final title? => title(t),
              null when fallbackToCategoryTitle => category.title(t),
              null => null,
            },
            entries: [
              for (final entry in category.entries)
                if (identical(entry.section, section)) entry,
            ],
          ),
      ],
    );
  }
}
