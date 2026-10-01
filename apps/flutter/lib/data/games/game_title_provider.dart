import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/games/games_provider.dart';
import '../settings/feature_flags_provider.dart';
import 'user_game_infos_provider.dart';

/// The games in memory, keyed by game id.
final gamesByIdProvider = Provider<Map<String, Game>>((ref) {
  final games = ref.watch(gamesProvider).value ?? const <Game>[];
  return {for (final game in games) game.path: game};
});

/// The name to display for the game with the given game id.
///
/// It is the name the user edited, or the default name of the game when none was edited, the edited
/// name is empty, or the game is not in memory.
///
/// With the performance improvements feature flag on, the game is looked up by id and only the
/// edited name of the given game is watched, so a change to another game does not recompute it.
final gameTitleProvider = Provider.family<String, String>((ref, gameId) {
  final performanceImprovements = ref.watch(performanceImprovementsProvider);
  final edited = performanceImprovements
      ? ref.watch(userGameInfosProvider.select((infos) => infos.value?[gameId]))
      : ref.watch(userGameInfosProvider).value?[gameId];
  if (edited != null && edited.isNotEmpty) return edited;
  final game = performanceImprovements
      ? ref.watch(gamesByIdProvider)[gameId]
      : (ref.watch(gamesProvider).value ?? const <Game>[])
            .where((game) => game.path == gameId)
            .firstOrNull;
  return game?.title ?? '';
});

/// Whether the game with the given game id has an edited name.
final isGameTitleEditedProvider = Provider.family<bool, String>((ref, gameId) {
  final edited = ref.watch(userGameInfosProvider).value?[gameId];
  return edited != null && edited.isNotEmpty;
});
