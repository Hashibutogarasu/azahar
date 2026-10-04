import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';

import 'emulation_drawer_header.dart';
import 'emulation_menu_actions.dart';
import 'emulation_menu_sections.dart';

/// The in-game drawer: a 300dp-wide panel rounded on the outer edge that starts with
/// [EmulationDrawerHeader]. Mobile passes it to [Scaffold.drawer], and the expanded
/// [EmulationSidePanel] of desktop shows the same widget, so both look the same when open.
class EmulationDrawer extends StatelessWidget {
  const EmulationDrawer({
    super.key,
    required this.gamePath,
    required this.game,
    required this.isPaused,
    required this.actions,
    this.headerTrailing,
  });

  static const width = 300.0;
  static const shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
  );

  final String gamePath;
  final Game? game;
  final bool isPaused;
  final EmulationMenuActions actions;
  final Widget? headerTrailing;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: width,
      shape: shape,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          EmulationDrawerHeader(
            gamePath: gamePath,
            game: game,
            isPaused: isPaused,
            trailing: headerTrailing,
          ),
          SafeArea(
            top: false,
            child: EmulationMenuSections(isPaused: isPaused, actions: actions),
          ),
        ],
      ),
    );
  }
}
