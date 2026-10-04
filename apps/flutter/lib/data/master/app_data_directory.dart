import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// The folder that holds the master database and, by default, the profile folders.
abstract final class AppDataDirectory {
  static const _name = 'azahar';

  static const profilesName = 'profiles';

  /// The app data folder on this platform.
  static Future<Directory> resolve() async {
    if (Platform.isLinux) return _xdgDataDirectory();
    return getApplicationDocumentsDirectory();
  }

  static Directory _xdgDataDirectory() {
    final dataHome = Platform.environment['XDG_DATA_HOME'];
    if (dataHome != null && p.isAbsolute(dataHome)) {
      return Directory(p.join(dataHome, _name));
    }
    final home = Platform.environment['HOME'];
    if (home == null) return Directory(p.join('/tmp', _name));
    return Directory(p.join(home, '.local', 'share', _name));
  }
}
