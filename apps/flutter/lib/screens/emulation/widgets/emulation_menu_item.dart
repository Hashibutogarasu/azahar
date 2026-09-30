import 'package:flutter/material.dart';

/// One action of the in-game menu: a [ListTile] normally, or just a tooltipped icon button when
/// [iconsOnly] is set.
class EmulationMenuItem extends StatelessWidget {
  const EmulationMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconsOnly = false,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool iconsOnly;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (iconsOnly) {
      return Align(
        child: IconButton(
          icon: Icon(icon),
          tooltip: title,
          onPressed: enabled ? onTap : null,
        ),
      );
    }
    return ListTile(
      enabled: enabled,
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
