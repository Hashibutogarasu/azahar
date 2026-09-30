import 'package:flutter/foundation.dart';

/// The actions offered by the in-game menu, shared by [EmulationDrawer] and [EmulationSidePanel].
@immutable
class EmulationMenuActions {
  const EmulationMenuActions({
    required this.onTogglePause,
    required this.onAdvanceFrame,
    required this.onCheats,
    required this.onCloseGame,
  });

  final VoidCallback onTogglePause;
  final VoidCallback onAdvanceFrame;

  /// Null while the running game is not known yet, which disables the entry.
  final VoidCallback? onCheats;
  final VoidCallback onCloseGame;
}
