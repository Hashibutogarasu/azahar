import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';

import 'tag_kind.dart';

/// A label that can be attached to games and used to filter the application list.
abstract class AbstractTag {
  const AbstractTag({required this.id, this.assignedPaths = const {}});

  final String id;
  final Set<String> assignedPaths;

  TagKind get kind;

  /// The color of the tag, white unless overridden.
  Color get color => Colors.white;

  /// The localized display name, resolved from the translations of [context].
  String name(BuildContext context);

  /// The tag specific rule describing which games this tag targets. Tags are never attached by it.
  List<Game> Function(List<Game> games) get onFilter;

  /// Returns only the games of [games] this tag is attached to, in their original order.
  ///
  /// A tag with no attached games returns an empty list.
  List<Game> filter(List<Game> games) {
    return games.where((game) => assignedPaths.contains(game.path)).toList();
  }
}
