import 'package:flutter/material.dart';

import '../../../data/options/categories/feature_flags_options.dart';
import '../../options/option_category_page.dart';

/// The feature flags page, defined as data by [featureFlagsOptionsProvider].
class FeatureFlagsPage extends StatelessWidget {
  const FeatureFlagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionCategoryPage(provider: featureFlagsOptionsProvider);
  }
}
