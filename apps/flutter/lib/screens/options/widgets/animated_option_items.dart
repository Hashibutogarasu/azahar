import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/options/option_entry.dart';
import '../../../data/settings/accessibility_settings_provider.dart';
import '../../../data/settings/advanced_settings_provider.dart';
import '../../../data/settings/animation_speed.dart';

/// Shows [entries] one below the other, animating the change whenever an item is added, removed
/// or moved, unless motion is reduced in the accessibility settings, in which case the list
/// changes at once. The speed follows the animation speed setting.
///
/// An item that moves is animated out of its old place and into its new one. [itemBuilder] turns
/// an entry into its widget. While the list is empty, [emptyMessage] is shown instead, if given.
class AnimatedOptionItems extends ConsumerStatefulWidget {
  const AnimatedOptionItems({
    super.key,
    required this.entries,
    required this.itemBuilder,
    this.emptyMessage,
  });

  final List<OptionEntry> entries;
  final Widget Function(OptionEntry entry) itemBuilder;
  final String? emptyMessage;

  @override
  ConsumerState<AnimatedOptionItems> createState() =>
      _AnimatedOptionItemsState();
}

class _AnimatedOptionItemsState extends ConsumerState<AnimatedOptionItems> {
  final _listKey = GlobalKey<AnimatedListState>();
  late List<OptionEntry> _shown = List.of(widget.entries);

  Duration get _duration => resolveAnimationDuration(
    reduceMotion: ref.read(accessibilitySettingsProvider).reduceMotion,
    speed: ref.read(advancedSettingsProvider).animationSpeed,
  );

  @override
  void didUpdateWidget(covariant AnimatedOptionItems oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncWith(widget.entries);
  }

  void _syncWith(List<OptionEntry> target) {
    final list = _listKey.currentState;
    if (list == null) {
      setState(() => _shown = List.of(target));
      return;
    }
    final targetIds = {for (final entry in target) entry.id};
    for (var i = _shown.length - 1; i >= 0; i--) {
      if (!targetIds.contains(_shown[i].id)) _removeAt(list, i);
    }
    for (var i = 0; i < target.length; i++) {
      if (i < _shown.length && _shown[i].id == target[i].id) {
        _shown[i] = target[i];
        continue;
      }
      final movedFrom = _shown.indexWhere((entry) => entry.id == target[i].id);
      if (movedFrom != -1) _removeAt(list, movedFrom);
      _shown.insert(i, target[i]);
      list.insertItem(i, duration: _duration);
    }
    setState(() {});
  }

  void _removeAt(AnimatedListState list, int index) {
    final removed = _shown.removeAt(index);
    list.removeItem(
      index,
      (context, animation) => _transition(removed, index, animation),
      duration: _duration,
    );
  }

  Widget _transition(
    OptionEntry entry,
    int index,
    Animation<double> animation,
  ) {
    return SizeTransition(
      key: ValueKey(entry.id),
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [if (index > 0) const Divider(), widget.itemBuilder(entry)],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedList(
          key: _listKey,
          initialItemCount: _shown.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index, animation) =>
              _transition(_shown[index], index, animation),
        ),
        if (_shown.isEmpty && widget.emptyMessage != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.emptyMessage!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
