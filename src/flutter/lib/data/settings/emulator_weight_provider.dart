import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../options/abstract_base_option.dart';
import '../options/option_categories_provider.dart';
import '../options/option_values_revision_provider.dart';

/// How heavy the current emulator settings make the emulation, from 0.0 to 1.0, where 1.0 (100%)
/// is the heaviest.
///
/// It is the sum of the share each [AbstractEmulatorOption] adds for its current value. The
/// graphics API has the largest share, then the internal resolution. It is computed again
/// whenever an option value changes.
final emulatorWeightIndexProvider = Provider<double>((ref) {
  ref.watch(optionValuesRevisionProvider);
  final total = ref
      .watch(optionEntriesProvider)
      .map((entry) => entry.option)
      .whereType<AbstractEmulatorOption<Object?>>()
      .fold<double>(0.0, (sum, option) => sum + option.currentWeight);
  return total.clamp(0.0, 1.0);
});
