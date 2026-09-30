import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reads and writes the value behind one Options item, whatever stores it.
///
/// [read] is called while building a widget, so an implementation backed by a Riverpod provider
/// can watch it. [write] gets the [BuildContext] for values whose change needs a dialog or a
/// navigation.
abstract class OptionValue<T> {
  const OptionValue();

  T read(WidgetRef ref);

  Future<void> write(BuildContext context, WidgetRef ref, T value);
}

/// An [OptionValue] defined by a pair of functions, for values backed by a provider or by any
/// other custom logic.
class CallbackOptionValue<T> extends OptionValue<T> {
  const CallbackOptionValue({required this.onRead, required this.onWrite});

  final T Function(WidgetRef ref) onRead;
  final Future<void> Function(BuildContext context, WidgetRef ref, T value)
  onWrite;

  @override
  T read(WidgetRef ref) => onRead(ref);

  @override
  Future<void> write(BuildContext context, WidgetRef ref, T value) =>
      onWrite(context, ref, value);
}
