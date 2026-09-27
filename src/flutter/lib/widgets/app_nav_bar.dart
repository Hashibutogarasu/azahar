import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../i18n/translations.g.dart';
import '../theme/extensions/app_navigation_bar_theme.dart';

/// The bottom navigation bar. Its shape (floating pill vs. flush full-width bar) and colors come
/// entirely from [AppNavigationBarTheme], so this single widget renders both the Azahar and
/// Legacy looks.
class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppNavigationBarTheme>()!;
    final t = context.t;
    final content = ClipRRect(
      borderRadius: theme.radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: theme.blurSigma, sigmaY: theme.blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: theme.radius,
            border: Border.all(color: theme.borderColor),
            boxShadow: theme.shadow,
          ),
          child: Padding(
            padding: theme.barPadding,
            child: Row(
              mainAxisSize: theme.stretchToFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: theme.stretchToFullWidth
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.center,
              children: [
                _AppNavDestination(
                  theme: theme,
                  icon: Icons.videogame_asset,
                  label: t.home.games,
                  selected: navigationShell.currentIndex == 0,
                  onTap: () => navigationShell.goBranch(
                    0,
                    initialLocation: navigationShell.currentIndex == 0,
                  ),
                ),
                if (!theme.stretchToFullWidth) const SizedBox(width: 24),
                _AppNavDestination(
                  theme: theme,
                  icon: Icons.more_horiz,
                  label: t.home.options,
                  selected: navigationShell.currentIndex == 1,
                  onTap: () => navigationShell.goBranch(
                    1,
                    initialLocation: navigationShell.currentIndex == 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return theme.stretchToFullWidth ? SizedBox(width: double.infinity, child: content) : content;
  }
}

class _AppNavDestination extends StatelessWidget {
  const _AppNavDestination({
    required this.theme,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final AppNavigationBarTheme theme;
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: theme.activeIndicatorSize.width,
            height: theme.activeIndicatorSize.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? theme.activeIndicatorColor : null,
              borderRadius: theme.activeIndicatorRadius,
            ),
            child: Icon(
              icon,
              size: 20,
              color: selected ? theme.activeIconColor : theme.inactiveIconColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: selected
                ? theme.activeLabelStyle.copyWith(color: theme.activeIconColor)
                : theme.inactiveLabelStyle.copyWith(color: theme.inactiveIconColor),
          ),
        ],
      ),
    );
  }
}
