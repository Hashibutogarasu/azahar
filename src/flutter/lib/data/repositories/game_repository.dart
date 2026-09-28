import 'package:drift/drift.dart';

import '../../models/game.dart' as model;
import '../database.dart';
import 'games_directory_repository.dart';
import 'installed_titles_repository.dart';

class GameRepository {
  GameRepository(
    this._db,
    this._gamesDirectoryRepository,
    this._installedTitlesRepository,
  );

  final AppDatabase _db;
  final GamesDirectoryRepository _gamesDirectoryRepository;
  final InstalledTitlesRepository _installedTitlesRepository;

  Future<List<model.Game>> cachedGames() async {
    final rows = await _db.select(_db.games).get();
    return rows.map(_fromRow).toList();
  }

  Future<List<model.Game>> rescan() async {
    final gamesDirectory = await _gamesDirectoryRepository.gamesDirectoryUri();
    final scanned = await _installedTitlesRepository.scan(gamesDirectory);
    await _db.batch((batch) {
      batch.deleteAll(_db.games);
      for (final game in scanned) {
        batch.insert(
          _db.games,
          _toCompanion(game),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    return scanned;
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
