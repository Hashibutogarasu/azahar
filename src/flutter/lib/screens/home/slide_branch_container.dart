import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/settings/accessibility_settings_provider.dart';
import '../../data/settings/advanced_settings_provider.dart';
import '../../data/settings/animation_speed.dart';

/// A [ShellNavigationContainerBuilder] for [AppShellRouteData] (see `app_routes.dart`) that
/// slides the previous and next branch content horizontally, in the direction implied by the
/// index change, instead of swapping instantly. All branches stay mounted (via [Offstage]) so
/// their navigation/scroll state survives switching tabs, same as the default indexed-stack
/// container.
Widget slideBranchContainerBuilder(
  BuildContext context,
  StatefulNavigationShell navigationShell,
  List<Widget> children,
) {
  return SlideBranchContainer(
    navigationShell: navigationShell,
    children: children,
  );
}

class SlideBranchContainer extends ConsumerStatefulWidget {
  const SlideBranchContainer({
    super.key,
    required this.navigationShell,
    required this.children,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  ConsumerState<SlideBranchContainer> createState() =>
      _SlideBranchContainerState();
}

class _SlideBranchContainerState extends ConsumerState<SlideBranchContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    value: 1,
    duration: const Duration(milliseconds: 300),
  );
  late int _currentIndex = widget.navigationShell.currentIndex;
  int? _previousIndex;
  int _direction = 1;

  @override
  void didUpdateWidget(covariant SlideBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newIndex = widget.navigationShell.currentIndex;
    if (newIndex == _currentIndex) return;
    final reduceMotion = ref.read(accessibilitySettingsProvider).reduceMotion;
    final animationSpeed = ref.read(advancedSettingsProvider).animationSpeed;
    setState(() {
      _direction = newIndex > _currentIndex ? 1 : -1;
      _previousIndex = _currentIndex;
      _currentIndex = newIndex;
    });
    _controller.duration = resolveAnimationDuration(
      reduceMotion: reduceMotion,
      speed: animationSpeed,
    );
    _controller.forward(from: 0).whenComplete(() {
      if (mounted) setState(() => _previousIndex = null);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var i = 0; i < widget.children.length; i++)
          Offstage(
            offstage: i != _currentIndex && i != _previousIndex,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final offset = switch (i) {
                  _ when i == _currentIndex =>
                    _direction * (1 - _controller.value),
                  _ when i == _previousIndex => -_direction * _controller.value,
                  _ => 0.0,
                };
                return FractionalTranslation(
                  translation: Offset(offset, 0),
                  child: child,
                );
              },
              child: widget.children[i],
            ),
          ),
      ],
    );
  }
}
