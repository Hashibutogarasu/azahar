import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/games/game_title_provider.dart';
import '../../data/tags/tags_provider.dart';
import 'games_provider.dart';

/// The games matching the search text and every selected tag.
///
/// A game matches the search text when its displayed name or its default name contains it.
final filteredGamesProvider = Provider<List<Game>>((ref) {
  final query = ref.watch(gameQueryProvider).toLowerCase();
  final selectedTagIds = ref.watch(selectedTagIdsProvider).value ?? const {};
  final tags = ref.watch(tagsProvider).value ?? const [];
  var games = ref.watch(gamesProvider).value ?? const <Game>[];
  if (query.isNotEmpty) {
    games = games.where((game) {
      final displayed = ref.watch(gameTitleProvider(game.path));
      return displayed.toLowerCase().contains(query) ||
          game.title.toLowerCase().contains(query);
    }).toList();
  }
  for (final tag in tags) {
    if (selectedTagIds.contains(tag.id)) games = tag.filter(games);
  }
  return games;
});
