import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../app_services.dart';
import '../../data/platform_provider.dart';
import '../../data/repositories/game_repository.dart';
import '../../data/tags/tags_provider.dart';
import '../../i18n/translations.g.dart';
import '../../widgets/app_search_bar.dart';
import 'filtered_games_provider.dart';
import 'game_process_provider.dart';
import 'games_provider.dart';
import 'widgets/about_game_bottom_sheet.dart';
import 'widgets/about_game_dialog.dart';
import 'widgets/game_card.dart';
import 'widgets/tag_filter_bar.dart';

class GamesListPage extends ConsumerStatefulWidget {
  const GamesListPage({super.key});

  @override
  ConsumerState<GamesListPage> createState() => _GamesListPageState();
}

class _GamesListPageState extends ConsumerState<GamesListPage>
    with WidgetsBindingObserver {
  final GameRepository _gameRepository = AppServices.gameRepository;
  late final _queryController = TextEditingController(
    text: ref.read(gameQueryProvider),
  );
  bool _wasRunning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(gamesProvider.notifier).rescan();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _queryController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(gamesProvider.notifier).rescan();
    }
  }

  void _showGameInfo(Game game) {
    final show = ref.read(isDesktopPlatformProvider)
        ? AboutGameDialog.show
        : AboutGameBottomSheet.show;
    show(
      context,
      game: game,
      onPlay: () => ref.read(gameProcessProvider.notifier).launch(game),
      onUninstalled: ref.read(gamesProvider.notifier).rescan,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final games = ref.watch(filteredGamesProvider);
    final hasGames = ref.watch(gamesProvider).value?.isNotEmpty ?? false;
    final tagsState = ref.watch(tagsProvider);
    final selectedTagIdsState = ref.watch(selectedTagIdsProvider);
    final isRunning = ref.watch(gameProcessProvider);
    final isDesktop = ref.watch(isDesktopPlatformProvider);
    if (_wasRunning && !isRunning) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(gamesProvider.notifier).rescan(),
      );
    }
    _wasRunning = isRunning;

    return SafeArea(
      child: Column(
        children: [
          AppSearchBar(
            controller: _queryController,
            hintText: t.games.searchHint,
            onChanged: ref.read(gameQueryProvider.notifier).update,
            onClear: () {
              _queryController.clear();
              ref.read(gameQueryProvider.notifier).update('');
            },
          ),
          TagFilterBar(
            tags: tagsState.value ?? const [],
            selectedTagIds: selectedTagIdsState.value ?? const {},
            enabled: tagsState.hasValue && selectedTagIdsState.hasValue,
            onToggle: ref.read(selectedTagIdsProvider.notifier).toggle,
            onSelectAll: ref.read(selectedTagIdsProvider.notifier).clear,
          ),
          Expanded(
            child: IgnorePointer(
              ignoring: isRunning,
              child: AnimatedOpacity(
                opacity: isRunning ? 0.5 : 1,
                duration: const Duration(milliseconds: 200),
                child: RefreshIndicator(
                  onRefresh: ref.read(gamesProvider.notifier).rescan,
                  child: games.isEmpty
                      ? ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                hasGames
                                    ? t.games.noMatchingGames
                                    : t.games.emptyGamelist,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: games.length,
                          itemBuilder: (context, index) {
                            final game = games[index];
                            return GameCard(
                              game: game,
                              isValidExtension: _gameRepository
                                  .isValidExtension(game),
                              onTap: () => ref
                                  .read(gameProcessProvider.notifier)
                                  .launch(game),
                              onInfo: () => _showGameInfo(game),
                              showInfoButton: isDesktop,
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
