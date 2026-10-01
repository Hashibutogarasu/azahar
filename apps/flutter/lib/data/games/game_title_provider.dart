import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/games/games_provider.dart';
import 'user_game_infos_provider.dart';

/// The name to display for the game with the given game id.
///
/// It is the name the user edited, or the default name of the game when none was edited, the edited
/// name is empty, or the game is not in memory.
final gameTitleProvider = Provider.family<String, String>((ref, gameId) {
  final games = ref.watch(gamesProvider).value ?? const [];
  final game = games.where((game) => game.path == gameId).firstOrNull;
  final edited = ref.watch(userGameInfosProvider).value?[gameId];
  if (edited != null && edited.isNotEmpty) return edited;
  return game?.title ?? '';
});

/// Whether the game with the given game id has an edited name.
final isGameTitleEditedProvider = Provider.family<bool, String>((ref, gameId) {
  final edited = ref.watch(userGameInfosProvider).value?[gameId];
  return edited != null && edited.isNotEmpty;
});
