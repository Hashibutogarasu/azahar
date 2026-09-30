import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/options/option_value.dart';
import '../../../../data/options/option_values_revision_provider.dart';

/// Writing an option value from a tile.
extension OptionCommit on WidgetRef {
  /// Writes [newValue] through [value], refreshes every option shown on screen, and reports the
  /// option as used through [onAccessed].
  Future<void> commitOptionValue<T>(
    BuildContext context,
    OptionValue<T> value,
    T newValue,
    VoidCallback onAccessed,
  ) async {
    await value.write(context, this, newValue);
    read(optionValuesRevisionProvider.notifier).bump();
    onAccessed();
  }
}
