import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';

/// The edited name of every game that has one, keyed by game id.
final userGameInfosProvider =
    AsyncNotifierProvider<UserGameInfosNotifier, Map<String, String?>>(
      UserGameInfosNotifier.new,
    );

class UserGameInfosNotifier extends AsyncNotifier<Map<String, String?>> {
  @override
  Future<Map<String, String?>> build() {
    return AppServices.userGameInfoRepository.readAll();
  }

  /// Stores [name] as the edited name of [gameId]. A null or blank [name] restores the default.
  Future<void> setName(String gameId, String? name) async {
    final trimmed = name?.trim();
    final stored = trimmed == null || trimmed.isEmpty ? null : trimmed;
    state = AsyncData({...?state.value, gameId: stored});
    await AppServices.userGameInfoRepository.setName(gameId, stored);
  }
}
