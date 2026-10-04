import 'dart:io';

/// The files an SQLite database at a path consists of.
abstract final class DatabaseFiles {
  static const _suffixes = ['', '-wal', '-shm'];

  /// Deletes the database at [path] together with its journal files.
  static Future<void> delete(String path) async {
    for (final suffix in _suffixes) {
      final file = File('$path$suffix');
      if (await file.exists()) await file.delete();
    }
  }

  /// The names of the files of the database named [name].
  static Iterable<String> names(String name) =>
      _suffixes.map((suffix) => '$name$suffix');
}
