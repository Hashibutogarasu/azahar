import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/extensions/app_navigation_bar_theme.dart';
import '../../theme/extensions/background_blob_theme.dart';
import '../../widgets/app_nav_bar.dart';
import '../../widgets/background_blobs.dart';

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
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final navBarTheme = Theme.of(context).extension<AppNavigationBarTheme>()!;
    final blobVariant =
        BackgroundBlobVariant.values[navigationShell.currentIndex];
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: BackgroundBlobs(variant: blobVariant)),
          if (navBarTheme.stretchToFullWidth)
            _NavBarInsets(navBarTheme: navBarTheme, child: navigationShell)
          else
            navigationShell,
          Positioned(
            left: navBarTheme.horizontalMargin,
            right: navBarTheme.horizontalMargin,
            bottom: navBarTheme.bottomMargin,
            child: navBarTheme.stretchToFullWidth
                ? AppNavBar(navigationShell: navigationShell)
                : Center(child: AppNavBar(navigationShell: navigationShell)),
          ),
        ],
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
