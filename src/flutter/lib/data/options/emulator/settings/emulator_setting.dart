import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../option_applicable.dart';
import '../../option_readable.dart';
import '../../option_value.dart';

/// Reads, writes and weighs one emulator setting that changes how heavy the emulation is.
///
/// A setting is also the [OptionValue] of the option that shows it, so the same object serves the
/// screen and the weight index.
abstract class EmulatorSetting<T> extends OptionValue<T>
    with OptionReadable<T>, OptionApplicable<T> {
  const EmulatorSetting();

  /// The largest share of the whole weight index this setting can add, between 0.0 and 1.0. The
  /// shares of all settings add up to 1.0.
  double get weightIndex;

  /// How much of [weightIndex] the value [value] costs, from 0.0 (nothing) to 1.0 (all of it).
  double weightFactor(T value);

  /// Returns the stored value without needing a widget reference.
  T readCurrent();

  /// Stores [value] and persists it without needing a widget reference.
  Future<void> writeCurrent(T value);

  /// The share of the whole weight index the current value adds.
  double get currentWeight => weightIndex * weightFactor(readCurrent());

  @override
  T read(WidgetRef ref) => readCurrent();

  @override
  Future<void> apply(BuildContext context, WidgetRef ref, T value) =>
      writeCurrent(value);

  @override
  Future<void> write(BuildContext context, WidgetRef ref, T value) =>
      apply(context, ref, value);
}
