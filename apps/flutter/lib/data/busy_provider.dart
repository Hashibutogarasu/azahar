import 'package:flutter_riverpod/flutter_riverpod.dart';

/// How many operations are running that must finish before the user may leave the page or
/// start another such operation. It is shared by every page, so a page only has to watch
/// [isBusyProvider] instead of knowing which operation is running.
final busyProvider = NotifierProvider<BusyNotifier, int>(BusyNotifier.new);

/// Whether an operation counted by [busyProvider] is running.
final isBusyProvider = Provider<bool>((ref) => ref.watch(busyProvider) > 0);

class BusyNotifier extends Notifier<int> {
  @override
  int build() => 0;

  /// Runs [task] while counting it, so the count also drops when [task] throws.
  Future<T> run<T>(Future<T> Function() task) async {
    state++;
    try {
      return await task();
    } finally {
      state--;
    }
  }
}
