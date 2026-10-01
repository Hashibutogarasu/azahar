import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';

/// The games cached in the database. [GamesNotifier.rescan] refreshes them from the games folder.
final gamesProvider = AsyncNotifierProvider<GamesNotifier, List<Game>>(
  GamesNotifier.new,
);

class GamesNotifier extends AsyncNotifier<List<Game>> {
  @override
  Future<List<Game>> build() {
    return AppServices.gameRepository.cachedGames();
  }

  /// Scans the games folder and replaces the games, once the cached games have been loaded.
  Future<void> rescan() async {
    await future;
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
