import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/translations.g.dart';

/// The bottom navigation shell across the Games/Options tabs, mirroring the original app's
/// `MainScreen` + `MainBottomNavigation`. Every other screen (emulation, settings, ...) lives
/// outside this shell.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) =>
            navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.videogame_asset_outlined),
            selectedIcon: const Icon(Icons.videogame_asset),
            label: t.home.games,
          ),
          NavigationDestination(
            icon: const Icon(Icons.more_horiz),
            label: t.home.options,
          ),
        ],
      ),
    );
  }
}
