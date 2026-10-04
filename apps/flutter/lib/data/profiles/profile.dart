import 'dart:convert';

import 'package:crypto/crypto.dart';

/// A user profile. Switching to it switches the emulator's user folder, and with it the NAND,
/// saves, cheats and installed titles, together with the games folder.
class Profile {
  const Profile({
    required this.cuid,
    required this.name,
    required this.userDirectory,
    required this.gamesDirectory,
    required this.databaseFile,
    required this.isBuiltIn,
    required this.createdAt,
  });

  final String cuid;
  final String name;
  final String userDirectory;
  final String? gamesDirectory;
  final String databaseFile;
  final bool isBuiltIn;
  final DateTime createdAt;

  /// Identifies the profile outside the app, such as the root of the profile in the file manager.
  /// It is the HMAC-SHA256 of [name] keyed by [cuid].
  String get hash =>
      Hmac(sha256, utf8.encode(cuid)).convert(utf8.encode(name)).toString();

  /// The name of the profile's folder in the profiles folder: `[name]-[the first five characters
  /// of cuid]`, with the characters a file name cannot hold in [name] replaced.
  String get folderName {
    final safeName = name
        .replaceAll(RegExp(r'[/\\:*?"<>|\x00-\x1F]'), '_')
        .trim();
    return '${safeName.isEmpty ? 'profile' : safeName}-${cuid.substring(0, 5)}';
  }
}
