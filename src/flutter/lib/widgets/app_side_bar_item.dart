import 'package:flutter/material.dart';

import '../theme/extensions/app_navigation_bar_theme.dart';
import 'app_nav_destination.dart';

/// One destination of [AppSideBar]: an icon with its label underneath.
class AppSideBarItem extends StatelessWidget {
  const AppSideBarItem({
    super.key,
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final AppNavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppNavigationBarTheme>()!;
    final color = selected ? theme.activeIconColor : theme.inactiveIconColor;
    final labelStyle = selected
        ? theme.activeLabelStyle
        : theme.inactiveLabelStyle;
    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: theme.activeIndicatorRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: theme.activeIndicatorSize.width,
                height: theme.activeIndicatorSize.height,
                decoration: BoxDecoration(
                  color: selected ? theme.activeIndicatorColor : null,
                  borderRadius: theme.activeIndicatorRadius,
                ),
                child: Icon(destination.icon, size: 20, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                destination.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: labelStyle.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
