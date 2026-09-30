import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';

/// The ids of the pinned Options items, in pin order.
final pinnedOptionsProvider =
    AsyncNotifierProvider<PinnedOptionsNotifier, List<String>>(
      PinnedOptionsNotifier.new,
    );

class PinnedOptionsNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() {
    return AppServices.pinnedOptionsRepository.readAll();
  }

  /// Pins [optionId]. Returns false when the pin limit was already reached.
  Future<bool> pin(String optionId) async {
    final pinned = await AppServices.pinnedOptionsRepository.pin(optionId);
    state = AsyncData(await AppServices.pinnedOptionsRepository.readAll());
    return pinned;
  }

  Future<void> clear() async {
    await AppServices.pinnedOptionsRepository.clear();
    state = const AsyncData([]);
  }

  Future<void> unpin(String optionId) async {
    await AppServices.pinnedOptionsRepository.unpin(optionId);
    state = AsyncData(await AppServices.pinnedOptionsRepository.readAll());
  }
}
