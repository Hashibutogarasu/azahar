import 'package:drift/drift.dart';

import '../database.dart';

class InputLayoutElementPosition {
  const InputLayoutElementPosition({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final int x;
  final int y;
  final int width;
  final int height;
}

class InputLayoutRepository {
  InputLayoutRepository(this._db);

  final AppDatabase _db;

  Future<InputLayoutElementPosition?> read(String orientation, String elementId) async {
    final row = await (_db.select(_db.inputLayoutElements)..where(
          (tbl) => tbl.orientation.equals(orientation) & tbl.elementId.equals(elementId),
        ))
        .getSingleOrNull();
    if (row == null) return null;
    return InputLayoutElementPosition(x: row.x, y: row.y, width: row.width, height: row.height);
  }

  Future<void> write(String orientation, String elementId, InputLayoutElementPosition position) {
    return _db.into(_db.inputLayoutElements).insertOnConflictUpdate(
      InputLayoutElementsCompanion.insert(
        orientation: orientation,
        elementId: elementId,
        x: position.x,
        y: position.y,
        width: position.width,
        height: position.height,
      ),
    );
  }
}
