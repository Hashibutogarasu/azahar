import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../data/repositories/game_repository.dart';
import '../../i18n/translations.g.dart';
import '../../models/game.dart';
import '../../theme/extensions/game_card_theme.dart';
import '../../widgets/app_search_bar.dart';
import 'game_process_provider.dart';
import 'widgets/about_game_bottom_sheet.dart';
import 'widgets/game_card.dart';

class GamesListPage extends ConsumerStatefulWidget {
  const GamesListPage({super.key});

  @override
  ConsumerState<GamesListPage> createState() => _GamesListPageState();
}

class _GamesListPageState extends ConsumerState<GamesListPage>
    with WidgetsBindingObserver {
  final GameRepository _gameRepository = AppServices.gameRepository;
  final _queryController = TextEditingController();
  List<Game> _games = const [];
  String _query = '';
  bool _wasRunning = false;

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
    return _games
        .where((game) => game.title.toLowerCase().contains(lowerQuery))
        .toList();
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
      onPlay: () => ref.read(gameProcessProvider.notifier).launch(game),
      onUninstalled: _rescan,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final games = _filteredGames;
    final cardTheme = Theme.of(context).extension<GameCardTheme>()!;
    final isRunning = ref.watch(gameProcessProvider);
    if (_wasRunning && !isRunning) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _rescan());
    }
    _wasRunning = isRunning;

    return SafeArea(
      child: Column(
        children: [
          AppSearchBar(
            controller: _queryController,
            hintText: t.games.searchHint,
            onChanged: (value) => setState(() => _query = value),
            onClear: () {
              _queryController.clear();
              setState(() => _query = '');
            },
          ),
          Expanded(
            child: IgnorePointer(
              ignoring: isRunning,
              child: AnimatedOpacity(
                opacity: isRunning ? 0.5 : 1,
                duration: const Duration(milliseconds: 200),
                child: RefreshIndicator(
                  onRefresh: _rescan,
                  child: games.isEmpty
                      ? ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                t.games.emptyGamelist,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: GameCard.maxWidth(
                                  cardTheme,
                                ),
                                mainAxisExtent: GameCard.height(cardTheme),
                              ),
                          itemCount: games.length,
                          itemBuilder: (context, index) {
                            final game = games[index];
                            return GameCard(
                              game: game,
                              onTap: () => ref
                                  .read(gameProcessProvider.notifier)
                                  .launch(game),
                              onLongPress: () => _onGameLongPress(game),
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
