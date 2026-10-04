import 'dart:async';

import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';

/// The games of the current profile.
///
/// The games cached in the database are shown first, and a scan of the games folder and the
/// installed titles starts at once and replaces them.
final gamesProvider = AsyncNotifierProvider<GamesNotifier, List<Game>>(
  GamesNotifier.new,
);

class GamesNotifier extends AsyncNotifier<List<Game>> {
  int _scanGeneration = 0;
  Future<void>? _scan;
  Future<void>? _queuedScan;
  int _scanHolds = 0;
  bool _scanHeldBack = false;

  @override
  Future<List<Game>> build() async {
    _scanGeneration++;
    _scan = null;
    _queuedScan = null;
    final cached = await _cachedGames();
    Future.microtask(rescan);
    return cached;
  }

  /// Scans the games folder and the installed titles and shows the games found.
  ///
  /// A call made while a scan is running queues one more scan after it, because the running
  /// scan may have started before the change the caller wants to see, such as an installed
  /// title. Calls made while a scan is queued share that scan. When the scan fails, the games
  /// shown so far stay and the error is kept in the state.
  Future<void> rescan() {
    if (_scanHolds > 0) {
      _scanHeldBack = true;
      return Future.value();
    }
    final running = _scan;
    if (running != null) {
      return _queuedScan ??= running.then((_) {
        _queuedScan = null;
        return rescan();
      });
    }
    late final Future<void> scan;
    scan = _runScan().whenComplete(() {
      if (identical(_scan, scan)) _scan = null;
    });
    return _scan = scan;
  }

  /// Waits for the running scan and holds back new ones, since a scan and a game share the core.
  Future<void> holdScans() async {
    _scanHolds++;
    final running = _scan;
    if (running != null) await running;
  }

  /// Ends one [holdScans] and runs the scan asked for meanwhile.
  void releaseScans() {
    if (_scanHolds == 0) return;
    _scanHolds--;
    if (_scanHolds > 0 || !_scanHeldBack) return;
    _scanHeldBack = false;
    unawaited(rescan());
  }

  Future<void> _runScan() async {
    final generation = _scanGeneration;
    try {
      final games = await AppServices.gameRepository.rescan();
      if (!_isCurrent(generation)) return;
      state = AsyncData(games);
    } catch (error, stackTrace) {
      debugPrint('Scanning the games failed: $error');
      if (!_isCurrent(generation)) return;
      state = AsyncError<List<Game>>(error, stackTrace);
    }
  }

  bool _isCurrent(int generation) =>
      ref.mounted && generation == _scanGeneration;

  Future<List<Game>> _cachedGames() async {
    try {
      return await AppServices.gameRepository.cachedGames();
    } catch (error) {
      debugPrint('Reading the cached games failed: $error');
      return const [];
    }
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
