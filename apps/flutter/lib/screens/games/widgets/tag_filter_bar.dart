import 'package:flutter/material.dart';

import '../../../data/tags/abstract_tag.dart';
import '../../../data/tags/tag_kind.dart';
import '../../../i18n/translations.g.dart';
import 'tag_chip.dart';

/// A horizontally scrolling row of tag chips headed by the "All" chip.
///
/// "All" is active while [selectedTagIds] is empty. Selecting any tag deactivates it.
class TagFilterBar extends StatelessWidget {
  const TagFilterBar({
    super.key,
    required this.tags,
    required this.selectedTagIds,
    required this.onToggle,
    required this.onSelectAll,
    this.enabled = true,
  });

  final List<AbstractTag> tags;
  final Set<String> selectedTagIds;
  final ValueChanged<String> onToggle;
  final VoidCallback onSelectAll;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          TagChip(
            label: context.t.tags[TagKind.all.name]!,
            color: Colors.white,
            selected: selectedTagIds.isEmpty,
            onTap: enabled ? onSelectAll : null,
          ),
          for (final tag in tags)
            TagChip(
              label: tag.name(context),
              color: tag.color,
              selected: selectedTagIds.contains(tag.id),
              onTap: enabled ? () => onToggle(tag.id) : null,
            ),
        ],
      ),
    );
  }
}
