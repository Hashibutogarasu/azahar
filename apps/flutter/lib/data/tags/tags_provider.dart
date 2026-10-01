import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import 'abstract_tag.dart';

/// Every stored tag with the games it is attached to.
final tagsProvider = AsyncNotifierProvider<TagsNotifier, List<AbstractTag>>(
  TagsNotifier.new,
);

class TagsNotifier extends AsyncNotifier<List<AbstractTag>> {
  @override
  Future<List<AbstractTag>> build() {
    return AppServices.tagRepository.readAll();
  }

  /// Attaches the tag [tagId] to the game at [gamePath], or detaches it when already attached.
  Future<void> toggle(String gamePath, String tagId) async {
    final attached = <String>{
      for (final tag in state.value ?? const <AbstractTag>[])
        if (tag.assignedPaths.contains(gamePath)) tag.id,
    };
    if (!attached.remove(tagId)) attached.add(tagId);
    await AppServices.tagRepository.setTags(gamePath, attached);
    state = AsyncData(await AppServices.tagRepository.readAll());
  }
}

/// The ids of the tags selected in the application list. Empty means the "All" tag is active.
final selectedTagIdsProvider =
    AsyncNotifierProvider<SelectedTagIdsNotifier, Set<String>>(
      SelectedTagIdsNotifier.new,
    );

class SelectedTagIdsNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() {
    return AppServices.selectedTagsRepository.readSelectedTagIds();
  }

  Future<void> toggle(String tagId) {
    final current = state.value ?? const <String>{};
    return _update(
      current.contains(tagId)
          ? ({...current}..remove(tagId))
          : {...current, tagId},
    );
  }

  Future<void> clear() => _update(const {});

  Future<void> _update(Set<String> tagIds) async {
    state = AsyncData(tagIds);
    await AppServices.selectedTagsRepository.writeSelectedTagIds(tagIds);
  }
}
