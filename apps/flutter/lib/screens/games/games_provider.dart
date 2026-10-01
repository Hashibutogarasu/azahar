import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../data/tags/tags_provider.dart';

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

/// The games matching the search text and every selected tag.
final filteredGamesProvider = Provider<List<Game>>((ref) {
  final query = ref.watch(gameQueryProvider).toLowerCase();
  final selectedTagIds = ref.watch(selectedTagIdsProvider).value ?? const {};
  final tags = ref.watch(tagsProvider).value ?? const [];
  var games = ref.watch(gamesProvider).value ?? const <Game>[];
  if (query.isNotEmpty) {
    games = games
        .where((game) => game.title.toLowerCase().contains(query))
        .toList();
  }
  for (final tag in tags) {
    if (selectedTagIds.contains(tag.id)) games = tag.filter(games);
  }
  return games;
});
