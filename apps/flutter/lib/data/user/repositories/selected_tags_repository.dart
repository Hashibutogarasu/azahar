import 'dart:convert';

import 'key_value_repository.dart';

/// Persists which tag filters are selected in the application list.
class SelectedTagsRepository extends KeyValueRepository {
  SelectedTagsRepository(super.db);

  final String _key = 'selected_tag_ids';

  /// Reads the ids of the selected tags. Empty means the "All" tag is active.
  Future<Set<String>> readSelectedTagIds() async {
    final value = await read(_key);
    if (value == null) return const {};
    return (jsonDecode(value) as List<dynamic>).cast<String>().toSet();
  }

  Future<void> writeSelectedTagIds(Set<String> tagIds) {
    return write(_key, jsonEncode(tagIds.toList()));
  }
}
