import 'dart:io';

import 'package:path/path.dart' as p;

/// Moves files and folders, also across file systems.
abstract final class FileMoves {
  static const _conflictSuffix = '.legacy';
  static const _stagingSuffix = '.partial';

  /// Moves [source] to [destination], copying through a `.partial` name when a rename fails.
  /// An existing folder is merged into; an existing file is kept and the moved one gets `.legacy`.
  static Future<void> move(FileSystemEntity source, String destination) async {
    final destinationType = await FileSystemEntity.type(
      destination,
      followLinks: false,
    );
    if (destinationType == FileSystemEntityType.notFound) {
      await _moveTo(source, destination);
      return;
    }
    final sourceIsDirectory = source is Directory;
    if (sourceIsDirectory &&
        destinationType == FileSystemEntityType.directory) {
      final target = Directory(destination);
      if (await target.list().isEmpty) {
        await target.delete();
        await _moveTo(source, destination);
        return;
      }
      for (final child in await source.list(followLinks: false).toList()) {
        await move(child, p.join(destination, p.basename(child.path)));
      }
      await source.delete(recursive: true);
      return;
    }
    await move(source, await _freeConflictPath(destination));
  }

  static Future<void> _moveTo(
    FileSystemEntity source,
    String destination,
  ) async {
    await Directory(p.dirname(destination)).create(recursive: true);
    try {
      await source.rename(destination);
    } on FileSystemException {
      final staging = '$destination$_stagingSuffix';
      if (await FileSystemEntity.type(staging, followLinks: false) !=
          FileSystemEntityType.notFound) {
        await _entity(staging).delete(recursive: true);
      }
      final copy = await _copy(source, staging);
      await copy.rename(destination);
      await source.delete(recursive: true);
    }
  }

  static Future<FileSystemEntity> _copy(
    FileSystemEntity source,
    String destination,
  ) async {
    switch (source) {
      case Link():
        return Link(destination).create(await source.target());
      case Directory():
        final directory = await Directory(destination).create(recursive: true);
        await for (final child in source.list(followLinks: false)) {
          await _copy(child, p.join(destination, p.basename(child.path)));
        }
        return directory;
      case File():
        return source.copy(destination);
      default:
        throw FileSystemException('Unsupported entry', source.path);
    }
  }

  static FileSystemEntity _entity(String path) {
    return switch (FileSystemEntity.typeSync(path, followLinks: false)) {
      FileSystemEntityType.directory => Directory(path),
      FileSystemEntityType.link => Link(path),
      _ => File(path),
    };
  }

  static Future<String> _freeConflictPath(String path) async {
    var candidate = '$path$_conflictSuffix';
    var index = 2;
    while (await FileSystemEntity.type(candidate, followLinks: false) !=
        FileSystemEntityType.notFound) {
      candidate = '$path$_conflictSuffix$index';
      index++;
    }
    return candidate;
  }
}
