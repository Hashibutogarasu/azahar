import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';

import '../../games/widgets/game_icon.dart';
import 'emulation_drawer.dart';
import 'emulation_menu_actions.dart';
import 'emulation_menu_sections.dart';

/// The in-game menu on desktop, where there is no way to open a drawer: a panel placed at the
/// left of the emulation screen. Expanded, it is the same [EmulationDrawer] as on mobile, with a
/// button to collapse it. Collapsed, it is a compact strip with only the icon of the game and the
/// icons of the menu, without the wave or the title, so it takes little room from the screens.
class EmulationSidePanel extends StatefulWidget {
  const EmulationSidePanel({
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
  State<EmulationSidePanel> createState() => _EmulationSidePanelState();
}

class _EmulationSidePanelState extends State<EmulationSidePanel> {
  static const double _collapsedWidth = 72;

  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    final width = _collapsed ? _collapsedWidth : EmulationDrawer.width;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: width,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.centerLeft,
          minWidth: width,
          maxWidth: width,
          child: _collapsed ? _collapsedPanel() : _expandedPanel(),
        ),
      ),
    );
  }

  Widget _expandedPanel() {
    return EmulationDrawer(
      gamePath: widget.gamePath,
      game: widget.game,
      isPaused: widget.isPaused,
      actions: widget.actions,
      headerTrailing: IconButton(
        icon: const Icon(Icons.menu_open),
        onPressed: () => setState(() => _collapsed = true),
      ),
    );
  }

  Widget _collapsedPanel() {
    return Drawer(
      width: _collapsedWidth,
      shape: EmulationDrawer.shape,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Align(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 40,
                height: 40,
                child: GameIcon(iconPath: widget.game?.iconPath),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => setState(() => _collapsed = false),
            ),
          ),
          EmulationMenuSections(
            isPaused: widget.isPaused,
            actions: widget.actions,
            iconsOnly: true,
          ),
        ],
      ),
    );
  }
}
