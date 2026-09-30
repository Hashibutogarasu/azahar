import 'package:drift/drift.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../database.dart';
import 'key_value_repository.dart';

class VirtualAccessPointsRepository extends KeyValueRepository {
  VirtualAccessPointsRepository(super.db);

  final String _enabledKey = 'virtual_network_enabled';

  Future<bool> isEnabled() => readBool(_enabledKey);

  Future<void> setEnabled(bool value) => writeBool(_enabledKey, value);

  Future<List<AccessPoint>> readAll() async {
    final rows = await (db.select(
      db.virtualAccessPoints,
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
    return db.transaction(() async {
      await db.delete(db.virtualAccessPoints).go();
      for (var i = 0; i < accessPoints.length; i++) {
        final accessPoint = accessPoints[i];
        await db
            .into(db.virtualAccessPoints)
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
