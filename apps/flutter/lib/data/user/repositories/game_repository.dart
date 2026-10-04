import 'package:drift/drift.dart';

import 'package:azahar_for_flutter/azahar_for_flutter.dart' as model;
import '../user_database.dart';
import '../../master/repositories/games_directory_repository.dart';
import '../../repositories/installed_titles_repository.dart';

class GameRepository {
  GameRepository(
    this._db,
    this._gamesDirectoryRepository,
    this._installedTitlesRepository,
  );

  final UserDatabase _db;
  final GamesDirectoryRepository _gamesDirectoryRepository;
  final InstalledTitlesRepository _installedTitlesRepository;

  Future<List<model.Game>> cachedGames() async {
    final rows = await (_db.select(
      _db.games,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.title)])).get();
    return rows.map(_fromRow).toList();
  }

  /// Scans the games folder and the installed titles, then makes the database match them.
  ///
  /// Rows of games that are still found are updated in place, so the times a game was added and
  /// last played survive the scan. Only the rows of games that are gone are removed.
  Future<List<model.Game>> rescan() async {
    final gamesDirectory = await _gamesDirectoryRepository.gamesDirectoryUri();
    final scanned = await _installedTitlesRepository.scan(gamesDirectory);
    await _saveScanned(scanned);
    return [...scanned]..sort((a, b) => a.title.compareTo(b.title));
  }

  /// Makes the games table match [scanned] without losing the data kept for each game.
  Future<void> _saveScanned(List<model.Game> scanned) {
    final paths = scanned.map((game) => game.path).toList();
    final now = DateTime.now();
    return _db.transaction(() async {
      await (_db.delete(
        _db.games,
      )..where((tbl) => tbl.path.isNotIn(paths))).go();
      await _db.batch((batch) {
        for (final game in scanned) {
          batch.insert(
            _db.games,
            _toCompanion(game).copyWith(addedToLibraryTime: Value(now)),
            onConflict: DoUpdate((_) => _toCompanion(game)),
          );
        }
      });
    });
  }

  bool isValidExtension(model.Game game) {
    final extension = game.filename.split('.').last.toLowerCase();
    return !model.GameExtensions.badExtensions.contains(extension);
  }

  Future<model.Game?> gameByPath(String path) async {
    final row = await (_db.select(
      _db.games,
    )..where((tbl) => tbl.path.equals(path))).getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  Future<void> markLastPlayed(String path) async {
    await (_db.update(_db.games)..where((tbl) => tbl.path.equals(path))).write(
      GamesCompanion(lastPlayedTime: Value(DateTime.now())),
    );
  }

  model.Game _fromRow(GameRow row) {
    return model.Game(
      title: row.title,
      description: row.description,
      path: row.path,
      titleId: row.titleId,
      company: row.company,
      regions: row.regions,
      isInstalled: row.isInstalled,
      isSystemTitle: row.isSystemTitle,
      isVisibleSystemTitle: row.isVisibleSystemTitle,
      filename: row.filename,
      iconPath: row.iconPath,
    );
  }

  GamesCompanion _toCompanion(model.Game game) {
    return GamesCompanion.insert(
      path: game.path,
      filename: game.filename,
      title: game.title,
      description: game.description,
      titleId: game.titleId,
      company: game.company,
      regions: game.regions,
      isInstalled: game.isInstalled,
      isSystemTitle: game.isSystemTitle,
      isVisibleSystemTitle: game.isVisibleSystemTitle,
      iconPath: Value(game.iconPath),
    );
  }
}
