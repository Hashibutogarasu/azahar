import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';

/// The ids of the Options items most recently changed or opened, most recent first.
final optionHistoryProvider =
    AsyncNotifierProvider<OptionHistoryNotifier, List<String>>(
      OptionHistoryNotifier.new,
    );

class OptionHistoryNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() {
    return AppServices.optionHistoryRepository.readRecent();
  }

  Future<void> remove(String optionId) async {
    await AppServices.optionHistoryRepository.remove(optionId);
    state = AsyncData(await AppServices.optionHistoryRepository.readRecent());
  }

  Future<void> clear() async {
    await AppServices.optionHistoryRepository.clear();
    state = const AsyncData([]);
  }

  Future<void> record(String optionId) async {
    await AppServices.optionHistoryRepository.record(optionId);
    state = AsyncData(await AppServices.optionHistoryRepository.readRecent());
  }
}
