import 'dart:io';

import 'package:cuid2/cuid2.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import 'app_data_directory.dart';

part 'master_database.g.dart';
part 'tables/master_settings.dart';
part 'tables/locations.dart';
part 'tables/profiles.dart';

/// The database every other piece of data is found from: where the app keeps its folders, the
/// profiles, and where the user database of each profile is.
@DriftDatabase(tables: [MasterSettings, Locations, Profiles])
class MasterDatabase extends _$MasterDatabase {
  MasterDatabase() : super(_openConnection());

  @visibleForTesting
  MasterDatabase.forTesting(super.e);

  static const fileName = 'master_data.sqlite';

  @override
  int get schemaVersion => 1;

  /// The master database file.
  static Future<File> file() async {
    final directory = await AppDataDirectory.resolve();
    return File(p.join(directory.path, fileName));
  }

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final file = await MasterDatabase.file();
      await file.parent.create(recursive: true);
      return NativeDatabase.createInBackground(file);
    });
  }
}
