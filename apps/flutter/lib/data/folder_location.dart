/// Converts between folder paths and the URIs folders are stored as.
abstract final class FolderLocation {
  /// [folder] as stored: a URI, with a path turned into a file URI.
  static String toUri(String folder) {
    if (folder.contains('://')) return folder;
    return Uri.directory(folder).toString();
  }

  /// The path of [location], a path or a file URI, or null when it has none.
  static String? toPath(String location) {
    if (!location.contains('://')) return location.isEmpty ? null : location;
    final uri = Uri.parse(location);
    return uri.scheme == 'file' ? uri.toFilePath() : null;
  }

  /// [location] for showing to the user: its path, or the name of a document tree.
  static String display(String location) {
    final path = toPath(location);
    if (path != null) return path;
    final segments = Uri.parse(location).pathSegments;
    return Uri.decodeComponent(segments.isEmpty ? '' : segments.last);
  }
}
