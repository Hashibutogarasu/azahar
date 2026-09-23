import 'package:flutter/material.dart';

import '../../app_services.dart';
import '../../data/game_repository.dart';
import '../../i18n/translations.g.dart';
import '../../models/game.dart';
import '../../routing/app_routes.dart';
import 'widgets/game_card.dart';

class GamesListPage extends StatefulWidget {
  const GamesListPage({super.key});

  @override
  State<GamesListPage> createState() => _GamesListPageState();
}

class _GamesListPageState extends State<GamesListPage> {
  final GameRepository _gameRepository = AppServices.gameRepository;
  List<Game> _games = const [];

  @override
  void initState() {
    super.initState();
    _loadCachedThenRescan();
  }

  Future<void> _loadCachedThenRescan() async {
    final cached = await _gameRepository.cachedGames();
    if (mounted) {
      setState(() => _games = cached);
    }
    await _rescan();
  }

  Future<void> _rescan() async {
    final scanned = await _gameRepository.rescan();
    if (mounted) {
      setState(() => _games = scanned);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.games.title)),
      body: RefreshIndicator(
        onRefresh: _rescan,
        child: _games.isEmpty
            ? ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(t.games.emptyGamelist, textAlign: TextAlign.center),
                  ),
                ],
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 600 ? 2 : 1;
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisExtent: 107,
                    ),
                    itemCount: _games.length,
                    itemBuilder: (context, index) {
                      final game = _games[index];
                      return GameCard(
                        game: game,
                        onTap: () async {
                          await _gameRepository.markLastPlayed(game.path);
                          if (context.mounted) {
                            EmulationRoute(
                              gamePath: Uri.encodeComponent(game.path),
                              $extra: game,
                            ).go(context);
                          }
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
