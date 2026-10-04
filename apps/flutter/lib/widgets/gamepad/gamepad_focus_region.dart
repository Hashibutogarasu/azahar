import 'package:flutter/widgets.dart';

/// A part of a screen, such as the navigation or a list, that a controller moves the focus
/// between as a whole. Entering a region focuses the item focused there last, or its first item.
class GamepadFocusRegion extends StatefulWidget {
  const GamepadFocusRegion({super.key, required this.child});

  final Widget child;

  static final Set<_GamepadFocusRegionState> _regions = {};

  /// Moves the focus to the region [offset] places after the one that holds it, wrapping around
  /// at both ends. When no region holds the focus, it moves to the first region.
  static void moveFocusBy(int offset) {
    final regions = _visibleRegions();
    if (regions.isEmpty) return;
    final current = regions.indexWhere((region) => region._node.hasFocus);
    if (current >= 0) {
      regions[current]._lastFocused = FocusManager.instance.primaryFocus;
    }
    final next = current < 0 ? 0 : (current + offset) % regions.length;
    regions[next]._focus();
  }

  static List<_GamepadFocusRegionState> _visibleRegions() {
    final visible = [
      for (final region in _regions)
        if (region._isVisible && region._candidates.isNotEmpty)
          (region: region, rect: region._rect),
    ];
    visible.sort((a, b) {
      final byTop = a.rect.top.round().compareTo(b.rect.top.round());
      return byTop != 0 ? byTop : a.rect.left.compareTo(b.rect.left);
    });
    return [for (final entry in visible) entry.region];
  }

  @override
  State<GamepadFocusRegion> createState() => _GamepadFocusRegionState();
}

class _GamepadFocusRegionState extends State<GamepadFocusRegion> {
  final FocusNode _node = FocusNode(
    debugLabel: 'GamepadFocusRegion',
    canRequestFocus: false,
    skipTraversal: true,
  );
  FocusNode? _lastFocused;

  @override
  void initState() {
    super.initState();
    GamepadFocusRegion._regions.add(this);
  }

  @override
  void dispose() {
    GamepadFocusRegion._regions.remove(this);
    _node.dispose();
    super.dispose();
  }

  bool get _isVisible {
    if (!mounted) return false;
    if (!TickerMode.valuesOf(context).enabled) return false;
    if (ModalRoute.of(context)?.isCurrent == false) return false;
    final box = context.findRenderObject();
    return box is RenderBox && box.hasSize && box.attached;
  }

  Rect get _rect {
    final box = context.findRenderObject()! as RenderBox;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  Iterable<FocusNode> get _candidates => _node.traversalDescendants.where(
    (node) => node.canRequestFocus && !node.skipTraversal,
  );

  void _focus() {
    final last = _lastFocused;
    if (last != null &&
        last.context != null &&
        last.canRequestFocus &&
        last.ancestors.contains(_node)) {
      last.requestFocus();
      return;
    }
    final candidates = _candidates;
    if (candidates.isEmpty) return;
    candidates.first.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _node,
      child: FocusTraversalGroup(child: widget.child),
    );
  }
}
