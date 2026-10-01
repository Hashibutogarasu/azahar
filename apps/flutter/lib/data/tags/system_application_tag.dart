import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';

import '../../i18n/translations.g.dart';
import 'abstract_tag.dart';
import 'tag_kind.dart';

/// Targets the 3DS system applications and the standard applications.
class SystemApplicationTag extends AbstractTag {
  const SystemApplicationTag({required super.id, super.assignedPaths});

  @override
  TagKind get kind => TagKind.system;

  @override
  Color get color => Colors.grey;

  @override
  String name(BuildContext context) => context.t.tags[kind.name]!;

  @override
  List<Game> Function(List<Game> games) get onFilter =>
      (games) => games.where((game) => game.isSystemTitle).toList();
}
