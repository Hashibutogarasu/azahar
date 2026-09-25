import 'package:drift/drift.dart';

import '../../models/access_point.dart';
import '../database.dart';

class VirtualAccessPointsRepository {
  VirtualAccessPointsRepository(this._db);

  final AppDatabase _db;

  Future<List<AccessPoint>> readAll() async {
    final rows = await (_db.select(
      _db.virtualAccessPoints,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.sortIndex)])).get();
    return rows
        .map(
          (row) => AccessPoint(
            ssid: row.ssid,
            bssid: row.bssid,
            frequency: row.frequency,
            level: row.level,
          ),
        )
        .toList();
  }

  Future<void> writeAll(List<AccessPoint> accessPoints) {
    return _db.transaction(() async {
      await _db.delete(_db.virtualAccessPoints).go();
      for (var i = 0; i < accessPoints.length; i++) {
        final accessPoint = accessPoints[i];
        await _db
            .into(_db.virtualAccessPoints)
            .insert(
              VirtualAccessPointsCompanion.insert(
                sortIndex: Value(i),
                ssid: accessPoint.ssid,
                bssid: accessPoint.bssid,
                frequency: accessPoint.frequency,
                level: accessPoint.level,
              ),
            );
      }
    });
  }
}
