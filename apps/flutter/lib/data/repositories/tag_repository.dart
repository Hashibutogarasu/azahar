import 'package:drift/drift.dart';

import '../database.dart';
import '../tags/abstract_tag.dart';
import '../tags/tag_factory.dart';
import '../tags/tag_kind.dart';

/// Stores the tags and the links between tags and games.
class TagRepository {
  TagRepository(this.db);

  final AppDatabase db;

  /// Inserts the persisted tags that do not exist yet. Existing tags keep their ids.
  Future<void> seedBuiltIns() {
    return db.transaction(() async {
      final rows = await db.select(db.tags).get();
      final existing = rows.map((row) => row.kind).toSet();
      for (final kind in TagKind.persisted) {
        if (existing.contains(kind.name)) continue;
        await db
            .into(db.tags)
            .insert(
              TagsCompanion.insert(
                kind: kind.name,
                sortIndex: TagKind.persisted.indexOf(kind),
              ),
            );
      }
    });
  }

  /// Reads every tag with the paths of the games it is attached to, seeding missing tags first.
  Future<List<AbstractTag>> readAll() async {
    await seedBuiltIns();
    final rows = await (db.select(
      db.tags,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.sortIndex)])).get();
    final links = await db.select(db.gameTags).get();
    final pathsByTag = <String, Set<String>>{};
    for (final link in links) {
      pathsByTag.putIfAbsent(link.tagId, () => {}).add(link.gamePath);
    }
    return rows
        .map(
          (row) => createTag(
            kind: TagKind.values.byName(row.kind),
            id: row.id,
            assignedPaths: pathsByTag[row.id] ?? const {},
          ),
        )
        .toList();
  }

  /// Replaces the tags attached to [gamePath] with [tagIds].
  Future<void> setTags(String gamePath, Set<String> tagIds) {
    return db.transaction(() async {
      await (db.delete(
        db.gameTags,
      )..where((tbl) => tbl.gamePath.equals(gamePath))).go();
      for (final tagId in tagIds) {
        await db
            .into(db.gameTags)
            .insert(GameTagsCompanion.insert(gamePath: gamePath, tagId: tagId));
      }
    });
  }
}
