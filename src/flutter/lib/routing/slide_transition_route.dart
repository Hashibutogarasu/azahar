import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/settings/accessibility_settings_provider.dart';
import '../data/settings/advanced_settings_provider.dart';
import '../data/settings/animation_speed.dart';

/// Mixed into [GoRouteData] subclasses for routes outside [AppShell] (settings pages, About,
/// System Files, ...), so pushing/popping them slides horizontally instead of using the platform
/// default transition. The transition's duration follows the Reduce Motion and Animation Speed
/// settings, same as the shell's own animations.
mixin SlideTransitionRoute on GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final container = ProviderScope.containerOf(context, listen: false);
    final reduceMotion = container
        .read(accessibilitySettingsProvider)
        .reduceMotion;
    final speed = container.read(advancedSettingsProvider).animationSpeed;
    final duration = resolveAnimationDuration(
      reduceMotion: reduceMotion,
      speed: speed,
    );
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: build(context, state),
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      },
    );
  }
}
