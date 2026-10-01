import 'abstract_tag.dart';
import 'hidden_application_tag.dart';
import 'modded_tag.dart';
import 'system_application_tag.dart';
import 'tag_kind.dart';
import 'user_installed_application_tag.dart';

/// Builds the tag implementation for a stored tag of [kind].
AbstractTag createTag({
  required TagKind kind,
  required String id,
  Set<String> assignedPaths = const {},
}) {
  return switch (kind) {
    TagKind.system => SystemApplicationTag(
      id: id,
      assignedPaths: assignedPaths,
    ),
    TagKind.userInstalled => UserInstalledApplicationTag(
      id: id,
      assignedPaths: assignedPaths,
    ),
    TagKind.hidden => HiddenApplicationTag(
      id: id,
      assignedPaths: assignedPaths,
    ),
    TagKind.modded => ModdedTag(id: id, assignedPaths: assignedPaths),
    TagKind.all => throw ArgumentError.value(
      kind,
      'kind',
      'The all tag is not stored',
    ),
  };
}
