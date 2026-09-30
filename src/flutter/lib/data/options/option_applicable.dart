import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Something that can put a new value of an option into effect.
mixin OptionApplicable<T> {
  /// Makes [value] the value of the option and persists it.
  Future<void> apply(BuildContext context, WidgetRef ref, T value);
}
