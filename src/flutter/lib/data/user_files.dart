import 'dart:io';

import 'package:path/path.dart' as p;

import '../native/native_bridge.dart';
import 'user_directory_bootstrap.dart';

/// Reads and writes files inside the user directory using paths relative to it.
abstract interface class UserFiles {
  factory UserFiles.forPlatform(NativeBridge nativeBridge) {
    return Platform.isLinux ? IoUserFiles() : BridgeUserFiles(nativeBridge);
  }

  Future<bool> append(String path, String text);

  Future<bool> rotate(String path, String previousPath);

  Future<bool> exists(String path);

  Future<bool> share(String path);
}

/// Uses `dart:io` against the directory confirmed in the setup wizard.
class IoUserFiles implements UserFiles {
  Future<File?> _file(String path) async {
    final root = await UserDirectoryBootstrap.readConfiguredDirectory();
    if (root == null) return null;
    return File(p.joinAll([root, ...p.posix.split(path)]));
  }

  @override
  Future<bool> append(String path, String text) async {
    final file = await _file(path);
    if (file == null) return false;
    try {
      await file.parent.create(recursive: true);
      await file.writeAsString(text, mode: FileMode.append, flush: true);
      return true;
    } on FileSystemException {
      return false;
    }
  }

  @override
  Future<bool> rotate(String path, String previousPath) async {
    final file = await _file(path);
    final previous = await _file(previousPath);
    if (file == null || previous == null) return false;
    try {
      if (!await file.exists()) return true;
      if (await previous.exists()) await previous.delete();
      await file.rename(previous.path);
      return true;
    } on FileSystemException {
      return false;
    }
  }

  @override
  Future<bool> exists(String path) async {
    final file = await _file(path);
    return file != null && await file.exists();
  }

  @override
  Future<bool> share(String path) async => false;
}

/// Goes through the native bridge, because the Android user directory is a document tree that
/// `dart:io` cannot open.
class BridgeUserFiles implements UserFiles {
  BridgeUserFiles(this._nativeBridge);

  final NativeBridge _nativeBridge;

  @override
  Future<bool> append(String path, String text) =>
      _nativeBridge.appendUserFile(path, text);

  @override
  Future<bool> rotate(String path, String previousPath) =>
      _nativeBridge.rotateUserFile(path, previousPath);

  @override
  Future<bool> exists(String path) => _nativeBridge.userFileExists(path);

  @override
  Future<bool> share(String path) => _nativeBridge.shareUserFile(path);
}
