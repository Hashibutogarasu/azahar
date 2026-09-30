import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/settings/accessibility_settings_provider.dart';
import '../data/settings/advanced_settings_provider.dart';
import '../data/settings/animation_speed.dart';

/// The base of the route definitions for pages outside the bottom navigation (settings pages,
/// About, System Files, ...). It builds the page with the transition the user chose in the
/// accessibility settings, taking it from [PageTransitionStyle], and uses the Reduce Motion and
/// Animation Speed settings for the duration, same as the shell's own animations.
abstract class AppRouteData extends GoRouteData {
  const AppRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final container = ProviderScope.containerOf(context, listen: false);
    final accessibility = container.read(accessibilitySettingsProvider);
    final duration = resolveAnimationDuration(
      reduceMotion: accessibility.reduceMotion,
      speed: container.read(advancedSettingsProvider).animationSpeed,
    );
    return accessibility.pageTransition.buildPage(
      state.pageKey,
      build(context, state),
      duration,
    );
  }
}
