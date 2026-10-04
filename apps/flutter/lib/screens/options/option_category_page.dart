import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/options/option_category.dart';
import '../../i18n/translations.g.dart';
import '../../widgets/busy_pop_scope.dart';
import 'widgets/option_category_cards.dart';

/// A page that shows the items of one [OptionCategory] provided by [provider], one card per
/// section in the order they are defined. The category title is the page title, and a section
/// without a title of its own gets a card without a heading.
class OptionCategoryPage extends ConsumerWidget {
  const OptionCategoryPage({super.key, required this.provider});

  final Provider<OptionCategory> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(provider);
    return BusyPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: busyBackButtonFor(context),
          title: Text(category.title(context.t)),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [OptionCategoryCards(category: category)],
        ),
      ),
    );
  }
}
