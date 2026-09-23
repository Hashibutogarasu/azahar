import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';

/// The in-game drawer opened from the emulation screen. Mirrors the shape of the original app's
/// `SidebarWidget` (a 300dp-wide panel rounded on the outer edge), but for now only carries the
/// "Other" section's close-game action; the rest of the sidebar's sections are not ported yet.
class EmulationDrawer extends StatelessWidget {
  const EmulationDrawer({super.key, required this.gameTitle, required this.onCloseGame});

  final String gameTitle;
  final VoidCallback onCloseGame;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Drawer(
      width: 300,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Text(gameTitle, style: Theme.of(context).textTheme.headlineMedium),
            ),
            _MenuSection(
              title: t.emulation.menuSectionOther,
              children: [
                _MenuItem(
                  icon: Icons.exit_to_app,
                  title: t.emulation.closeGame,
                  onTap: onCloseGame,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}
