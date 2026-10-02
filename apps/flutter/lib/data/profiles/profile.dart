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
    required this.isBuiltIn,
    required this.createdAt,
  });

  final String cuid;
  final String name;

  /// The URI of the folder that holds the profile's data.
  final String userDirectory;

  /// The URI of the folder that is scanned for games, or null when none was chosen.
  final String? gamesDirectory;

  /// Whether the app created this profile in its documents folder.
  final bool isBuiltIn;

  final DateTime createdAt;

  /// Identifies the profile outside the app, such as the root of the profile in the file manager
  /// and the folder of the built-in profile. It is the HMAC-SHA256 of [name] keyed by [cuid].
  String get hash =>
      Hmac(sha256, utf8.encode(cuid)).convert(utf8.encode(name)).toString();
}
