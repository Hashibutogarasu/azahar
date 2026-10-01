import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';

import '../../i18n/translations.g.dart';
import 'abstract_tag.dart';
import 'tag_kind.dart';

/// Targets the applications the user installed.
class UserInstalledApplicationTag extends AbstractTag {
  const UserInstalledApplicationTag({required super.id, super.assignedPaths});

  @override
  TagKind get kind => TagKind.userInstalled;

  @override
  Color get color => Colors.green;

  @override
  String name(BuildContext context) => context.t.tags[kind.name]!;

  @override
  List<Game> Function(List<Game> games) get onFilter =>
      (games) => games
          .where((game) => game.isInstalled && !game.isSystemTitle)
          .toList();
}
