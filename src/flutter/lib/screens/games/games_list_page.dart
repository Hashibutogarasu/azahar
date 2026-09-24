import 'package:flutter/material.dart';

import '../../app_services.dart';
import '../../data/game_repository.dart';
import '../../i18n/translations.g.dart';
import '../../models/game.dart';
import 'widgets/about_game_bottom_sheet.dart';
import 'widgets/game_card.dart';

class GamesListPage extends StatefulWidget {
  const GamesListPage({super.key});

  @override
  State<GamesListPage> createState() => _GamesListPageState();
}

class _GamesListPageState extends State<GamesListPage> with WidgetsBindingObserver {
  final GameRepository _gameRepository = AppServices.gameRepository;
  final _queryController = TextEditingController();
  List<Game> _games = const [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCachedThenRescan();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _queryController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _rescan();
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

  List<Game> get _filteredGames {
    if (_query.isEmpty) return _games;
    final lowerQuery = _query.toLowerCase();
    return _games.where((game) => game.title.toLowerCase().contains(lowerQuery)).toList();
  }

  Future<void> _launchGame(Game game) async {
    await _gameRepository.markLastPlayed(game.path);
    await AppServices.nativeBridge.launchEmulationActivity(game.path);
  }

  void _onGameLongPress(Game game) {
    final t = context.t;
    if (game.titleId == 0) {
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(t.games.properties),
          content: Text(t.games.propertiesNotLoaded),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
        ),
      );
      return;
    }
    AboutGameBottomSheet.show(
      context,
      game: game,
      onPlay: () => _launchGame(game),
      onUninstalled: _rescan,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final games = _filteredGames;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(Icons.search, size: 28),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _queryController,
                          decoration: InputDecoration(
                            hintText: t.games.searchHint,
                            border: InputBorder.none,
                          ),
                          onChanged: (value) => setState(() => _query = value),
                        ),
                      ),
                      if (_query.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _queryController.clear();
                            setState(() => _query = '');
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _rescan,
                child: games.isEmpty
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
                            itemCount: games.length,
                            itemBuilder: (context, index) {
                              final game = games[index];
                              return GameCard(
                                game: game,
                                onTap: () => _launchGame(game),
                                onLongPress: () => _onGameLongPress(game),
                              );
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
