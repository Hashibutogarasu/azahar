import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Counts the option values written so far.
///
/// Many options read their value from a store that does not notify listeners. Every widget that
/// shows options watches this, so that a change made from one place, such as the history or a
/// search result, refreshes the same option shown everywhere else.
final optionValuesRevisionProvider =
    NotifierProvider<OptionValuesRevisionNotifier, int>(
      OptionValuesRevisionNotifier.new,
    );

class OptionValuesRevisionNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}
