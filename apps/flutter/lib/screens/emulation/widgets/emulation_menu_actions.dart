import 'package:flutter/foundation.dart';

/// The actions offered by the in-game menu, shared by [EmulationDrawer] and [EmulationSidePanel].
@immutable
class EmulationMenuActions {
  const EmulationMenuActions({
    required this.onTogglePause,
    required this.onAdvanceFrame,
    required this.onCheats,
    required this.onSaveAndExit,
    required this.onExitWithoutSaving,
  });

  final VoidCallback onTogglePause;
  final VoidCallback onAdvanceFrame;

  /// Null while the running game is not known yet, which disables the entry.
  final VoidCallback? onCheats;

  /// Stops the game and writes what it changed to the storage.
  final VoidCallback onSaveAndExit;

  /// Stops the game and discards what it changed since it started.
  final VoidCallback onExitWithoutSaving;
}
