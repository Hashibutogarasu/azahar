import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../games/widgets/game_icon.dart';
import '../emulation_focus_provider.dart';
import 'emulation_drawer.dart';
import 'emulation_menu_actions.dart';
import 'emulation_menu_sections.dart';

/// The in-game menu on desktop, where there is no way to open a drawer: a panel placed at the
/// left of the emulation screen. Expanded, it is the same [EmulationDrawer] as on mobile, with a
/// button to collapse it. Collapsed, it is a compact strip with only the icon of the game and the
/// icons of the menu, without the wave or the title, so it takes little room from the screens.
/// It expands and takes the focus when [emulationFocusProvider] moves controller input to the menu.
class EmulationSidePanel extends ConsumerStatefulWidget {
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
  ConsumerState<EmulationSidePanel> createState() => _EmulationSidePanelState();
}

class _EmulationSidePanelState extends ConsumerState<EmulationSidePanel> {
  static const double _collapsedWidth = 72;

  final FocusScopeNode _scope = FocusScopeNode(
    debugLabel: 'EmulationSidePanel',
  );
  bool _collapsed = false;

  @override
  void dispose() {
    _scope.dispose();
    super.dispose();
  }

  void _onFocusChanged(EmulationFocus focus) {
    switch (focus) {
      case EmulationFocus.menu:
        setState(() => _collapsed = false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _scope.requestFocus();
        });
      case EmulationFocus.game:
        _scope.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      emulationFocusProvider.select((state) => state.focus),
      (_, focus) => _onFocusChanged(focus),
    );
    final width = _collapsed ? _collapsedWidth : EmulationDrawer.width;
    return FocusScope(
      node: _scope,
      child: AnimatedContainer(
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
