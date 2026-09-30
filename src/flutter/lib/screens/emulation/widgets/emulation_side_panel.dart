import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';

import 'emulation_menu_actions.dart';
import 'emulation_menu_sections.dart';
import 'game_title.dart';

/// The in-game menu on desktop, where there is no way to open a drawer: a square-cornered panel
/// placed at the left of the emulation screen that can be collapsed to a strip of icons.
class EmulationSidePanel extends StatefulWidget {
  const EmulationSidePanel({
    super.key,
    required this.game,
    required this.isPaused,
    required this.actions,
  });

  final Game? game;
  final bool isPaused;
  final EmulationMenuActions actions;

  @override
  State<EmulationSidePanel> createState() => _EmulationSidePanelState();
}

class _EmulationSidePanelState extends State<EmulationSidePanel> {
  static const double _expandedWidth = 300;
  static const double _collapsedWidth = 72;

  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: _collapsed ? _collapsedWidth : _expandedWidth,
      child: Material(
        color: theme.colorScheme.surface,
        child: ListView(
          children: [
            if (_collapsed)
              Align(
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => setState(() => _collapsed = false),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: GameTitle(
                        game: widget.game,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu_open),
                      onPressed: () => setState(() => _collapsed = true),
                    ),
                  ],
                ),
              ),
            EmulationMenuSections(
              isPaused: widget.isPaused,
              actions: widget.actions,
              iconsOnly: _collapsed,
            ),
          ],
        ),
      ),
    );
  }
}
