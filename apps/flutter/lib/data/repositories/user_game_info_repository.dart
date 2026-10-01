import 'package:drift/drift.dart';

import '../database.dart';

/// Stores the information about games that the user edited.
class UserGameInfoRepository {
  UserGameInfoRepository(this.db);

  final AppDatabase db;

  /// Reads the edited name of every game that has a row, keyed by game id.
  Future<Map<String, String?>> readAll() async {
    final rows = await db.select(db.userGameInfos).get();
    return {for (final row in rows) row.gameId: row.name};
  }

  /// Stores [name] as the name of [gameId]. A null or blank [name] clears the edited name.
  Future<void> setName(String gameId, String? name) {
    final trimmed = name?.trim();
    return db
        .into(db.userGameInfos)
        .insertOnConflictUpdate(
          UserGameInfosCompanion.insert(
            gameId: gameId,
            name: Value(trimmed == null || trimmed.isEmpty ? null : trimmed),
          ),
        );
  }
}
