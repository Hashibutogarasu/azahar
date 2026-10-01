/// Identifies a tag. [name] doubles as the key under `tags` in the translation files.
enum TagKind {
  /// The pseudo tag meaning "no filter". It is never stored or attached to a game.
  all,
  system,
  userInstalled,
  hidden,
  modded;

  static const List<TagKind> persisted = [
    system,
    userInstalled,
    hidden,
    modded,
  ];
}
