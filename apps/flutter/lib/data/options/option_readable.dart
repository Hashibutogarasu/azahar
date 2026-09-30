import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Something that can return the current value of an option.
mixin OptionReadable<T> {
  /// Returns the value the option holds now.
  T read(WidgetRef ref);
}
