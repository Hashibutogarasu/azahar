import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';

/// The scanned games. Starts with the cached games and refreshes them with a rescan.
final gamesProvider = AsyncNotifierProvider<GamesNotifier, List<Game>>(
  GamesNotifier.new,
);

class GamesNotifier extends AsyncNotifier<List<Game>> {
  @override
  Future<List<Game>> build() async {
    final cached = await AppServices.gameRepository.cachedGames();
    Future.microtask(rescan);
    return cached;
  }

  Future<void> rescan() async {
    state = AsyncData(await AppServices.gameRepository.rescan());
  }
}

/// The text typed in the search bar of the application list.
final gameQueryProvider = NotifierProvider<GameQueryNotifier, String>(
  GameQueryNotifier.new,
);

class GameQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;
}
