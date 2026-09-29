import 'package:flutter/material.dart';
import 'package:glass_bottom_navigation/glass_bottom_navigation.dart';
import 'package:go_router/go_router.dart';

import '../i18n/translations.g.dart';
import '../theme/extensions/app_navigation_bar_theme.dart';

/// The bottom navigation bar. Its shape (floating pill vs. flush full-width bar) and colors come
/// entirely from [AppNavigationBarTheme], so this single widget renders both the Azahar and
/// Legacy looks. The Azahar look is a [GlassBottomBar], which animates its own selection glass;
/// the Legacy look slides a flat active-item indicator using [animationDuration].
class AppNavBar extends StatelessWidget {
  const AppNavBar({
    super.key,
    required this.navigationShell,
    required this.animationDuration,
  });

  final StatefulNavigationShell navigationShell;
  final Duration animationDuration;

  static const double _slotWidth = 88;
  static const double _itemHeight = 48;
  static const double _glassBarHeightExtra = 8;
  static const EdgeInsets _glassBarPadding = EdgeInsets.all(12);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppNavigationBarTheme>()!;
    final t = context.t;
    final destinations = [
      (icon: Icons.videogame_asset, label: t.home.games),
      (icon: Icons.more_horiz, label: t.home.options),
    ];

    void onTap(int index) => navigationShell.goBranch(
      index,
      initialLocation: navigationShell.currentIndex == index,
    );

    if (theme.blurSigma > 0) {
      return GlassBottomBar(
        items: [
          for (final destination in destinations)
            GlassBarItem(icon: destination.icon, label: destination.label),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: onTap,
        width: _slotWidth * destinations.length + _glassBarPadding.horizontal,
        height: _itemHeight - _glassBarHeightExtra + _glassBarPadding.vertical,
        style: GlassBottomNavStyle(
          accent: theme.activeIconColor,
          inactiveIconColor: theme.inactiveIconColor,
          showLabels: false,
          pillTint: theme.backgroundColor,
          radius: theme.radius.topLeft.x,
          barPadding: _glassBarPadding,
          selectedSideInsetPx: 0,
          selectedInsetPx: 0,
        ),
      );
    }

    final content = Material(
      color: theme.backgroundColor,
      borderRadius: theme.radius,
      elevation: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: theme.radius,
          boxShadow: theme.shadow,
        ),
        child: Padding(
          padding: theme.barPadding,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = theme.stretchToFullWidth
                  ? constraints.maxWidth
                  : _slotWidth * destinations.length;
              final slotWidth = barWidth / destinations.length;
              final indicatorLeft =
                  navigationShell.currentIndex * slotWidth +
                  (slotWidth - theme.activeIndicatorSize.width) / 2;
              return SizedBox(
                width: barWidth,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: animationDuration,
                      curve: Curves.easeInOut,
                      left: indicatorLeft,
                      top: 0,
                      width: theme.activeIndicatorSize.width,
                      height: theme.activeIndicatorSize.height,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.activeIndicatorColor,
                          borderRadius: theme.activeIndicatorRadius,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < destinations.length; i++)
                          SizedBox(
                            width: slotWidth,
                            child: _AppNavDestination(
                              theme: theme,
                              icon: destinations[i].icon,
                              label: destinations[i].label,
                              selected: navigationShell.currentIndex == i,
                              onTap: () => onTap(i),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
    return theme.stretchToFullWidth
        ? SizedBox(width: double.infinity, child: content)
        : content;
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
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: theme.activeIndicatorSize.height,
          child: Center(
            child: Icon(
              icon,
              size: 20,
              color: selected ? theme.activeIconColor : theme.inactiveIconColor,
            ),
          ),
        ),
      ),
    );
  }
}
