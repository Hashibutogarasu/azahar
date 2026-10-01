import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';

import '../../games/widgets/game_icon.dart';
import 'emulation_menu_actions.dart';
import 'emulation_menu_sections.dart';
import 'game_title.dart';

/// The in-game drawer opened from the emulation screen on mobile: a 300dp-wide panel rounded on
/// the outer edge, to be passed to [Scaffold.drawer]. It starts with the icon and the name of the
/// running game. Desktop uses [EmulationSidePanel] instead.
class EmulationDrawer extends StatelessWidget {
  const EmulationDrawer({
    super.key,
    required this.gamePath,
    required this.game,
    required this.isPaused,
    required this.actions,
  });

  final String gamePath;
  final Game? game;
  final bool isPaused;
  final EmulationMenuActions actions;

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      width: 96,
                      height: 96,
                      child: GameIcon(iconPath: game?.iconPath),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GameTitle(
                    gamePath: gamePath,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            EmulationMenuSections(isPaused: isPaused, actions: actions),
          ],
        ),
      ),
    );
  }
}
