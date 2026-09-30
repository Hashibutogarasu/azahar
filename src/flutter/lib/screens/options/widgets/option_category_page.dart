import 'package:flutter/material.dart';

import '../../../data/options/option_category.dart';
import '../../../data/options/translation_lookup.dart';
import '../../../i18n/translations.g.dart';
import 'option_category_cards.dart';

/// A settings page generated from an [OptionCategory]: a scaffold titled with the category and its
/// sections shown as cards.
class OptionCategoryPage extends StatelessWidget {
  const OptionCategoryPage({super.key, required this.category});

  final OptionCategory category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.resolve(category.titleKey))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [OptionCategoryCards(category: category)],
      ),
    );
  }
}
