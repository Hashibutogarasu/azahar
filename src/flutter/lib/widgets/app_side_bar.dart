import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/extensions/app_navigation_bar_theme.dart';
import 'app_nav_destination.dart';
import 'app_side_bar_item.dart';

/// The app shell's navigation on desktop, replacing [AppNavBar]: a compact square-cornered
/// sidebar listing each destination as an icon with its label.
class AppSideBar extends StatelessWidget {
  const AppSideBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const double _width = 96;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppNavigationBarTheme>()!;
    final destinations = AppNavDestination.of(context);
    return SizedBox(
      width: _width,
      child: Material(
        color: theme.backgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            for (var i = 0; i < destinations.length; i++)
              AppSideBarItem(
                destination: destinations[i],
                selected: navigationShell.currentIndex == i,
                onTap: () => navigationShell.goBranch(
                  i,
                  initialLocation: navigationShell.currentIndex == i,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
