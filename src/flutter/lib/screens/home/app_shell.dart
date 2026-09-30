import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/platform_provider.dart';
import '../../data/settings/accessibility_settings_provider.dart';
import '../../data/settings/advanced_settings_provider.dart';
import '../../data/settings/animation_speed.dart';
import '../../theme/extensions/app_navigation_bar_theme.dart';
import '../../theme/extensions/background_blob_theme.dart';
import '../../widgets/app_nav_bar.dart';
import '../../widgets/background_blobs.dart';
import 'desktop_app_shell.dart';

/// The bottom navigation shell across the Games/Options tabs, mirroring the original app's
/// `MainScreen` + `MainBottomNavigation`. Every other screen (emulation, settings, ...) lives
/// outside this shell. [AppNavBar]'s shape (floating pill vs. flush full-width bar) comes
/// entirely from the active [AppNavigationBarTheme]. The decorative background blobs are drawn
/// here too, so every branch gets them without each page having to add its own.
///
/// When the nav bar floats (a translucent pill, not [AppNavigationBarTheme.stretchToFullWidth]),
/// content is allowed to run edge-to-edge behind it instead of reserving opaque space for it,
/// so the bar only ever shows page content and blobs through its own blur, never a bare
/// background. Only the flush, opaque Legacy bar reserves real space so it isn't drawn over.
///
/// The bar slides out of view while a descendant scroll view is being scrolled down, and back
/// into view when scrolling back up, unless `reduceMotion` is enabled, in which case it stays put
/// (the transition still happens, just instantly).
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  bool _navBarVisible = true;

  bool _handleScrollNotification(UserScrollNotification notification) {
    switch (notification.direction) {
      case ScrollDirection.reverse:
        if (_navBarVisible) setState(() => _navBarVisible = false);
      case ScrollDirection.forward:
        if (!_navBarVisible) setState(() => _navBarVisible = true);
      case ScrollDirection.idle:
        break;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final navBarTheme = Theme.of(context).extension<AppNavigationBarTheme>()!;
    final blobVariant =
        BackgroundBlobVariant.values[widget.navigationShell.currentIndex];
    final reduceMotion = ref.watch(accessibilitySettingsProvider).reduceMotion;
    final animationSpeed = ref.watch(advancedSettingsProvider).animationSpeed;
    final animationDuration = resolveAnimationDuration(
      reduceMotion: reduceMotion,
      speed: animationSpeed,
    );
    if (ref.watch(isDesktopPlatformProvider)) {
      return DesktopAppShell(navigationShell: widget.navigationShell);
    }
    final hiddenBottomOffset =
        -(navBarTheme.barHeight + navBarTheme.bottomMargin + 32);
    return Scaffold(
      body: NotificationListener<UserScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Stack(
          children: [
            Positioned.fill(child: BackgroundBlobs(variant: blobVariant)),
            if (navBarTheme.stretchToFullWidth)
              _NavBarInsets(
                navBarTheme: navBarTheme,
                child: widget.navigationShell,
              )
            else
              widget.navigationShell,
            AnimatedPositioned(
              duration: animationDuration,
              curve: Curves.easeInOut,
              left: navBarTheme.horizontalMargin,
              right: navBarTheme.horizontalMargin,
              bottom: _navBarVisible
                  ? navBarTheme.bottomMargin
                  : hiddenBottomOffset,
              child: AnimatedOpacity(
                duration: animationDuration,
                opacity: _navBarVisible ? 1 : 0,
                child: navBarTheme.stretchToFullWidth
                    ? AppNavBar(
                        navigationShell: widget.navigationShell,
                        animationDuration: animationDuration,
                      )
                    : Center(
                        child: AppNavBar(
                          navigationShell: widget.navigationShell,
                          animationDuration: animationDuration,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grows the ambient [MediaQuery] bottom padding by the nav bar's height, so `SafeArea`s inside
/// [child] leave room for the flush, opaque bar instead of being covered by it.
class _NavBarInsets extends StatelessWidget {
  const _NavBarInsets({required this.navBarTheme, required this.child});

  final AppNavigationBarTheme navBarTheme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final extraBottomInset = navBarTheme.barHeight + navBarTheme.bottomMargin;
    return MediaQuery(
      data: mediaQuery.copyWith(
        padding: mediaQuery.padding.copyWith(
          bottom: mediaQuery.padding.bottom + extraBottomInset,
        ),
      ),
      child: child,
    );
  }
}
