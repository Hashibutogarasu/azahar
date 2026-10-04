import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where controller input goes while a game runs: the running game, or the in-game menu, which is
/// the side panel on desktop and the drawer on mobile.
enum EmulationFocus { game, menu }

/// Whether the emulation screen is shown, and where controller input goes on it.
class EmulationFocusState {
  const EmulationFocusState({
    this.isActive = false,
    this.focus = EmulationFocus.game,
  });

  final bool isActive;

  final EmulationFocus focus;

  bool get isGameFocused => isActive && focus == EmulationFocus.game;

  bool get isMenuFocused => isActive && focus == EmulationFocus.menu;

  EmulationFocusState copyWith({bool? isActive, EmulationFocus? focus}) {
    return EmulationFocusState(
      isActive: isActive ?? this.isActive,
      focus: focus ?? this.focus,
    );
  }
}

/// Whether the emulation screen is shown, and where controller input goes on it.
final emulationFocusProvider =
    NotifierProvider<EmulationFocusNotifier, EmulationFocusState>(
      EmulationFocusNotifier.new,
    );

/// Keeps [emulationFocusProvider] up to date. The emulation screen marks itself shown and hidden,
/// and the focus moves between the game and the menu.
class EmulationFocusNotifier extends Notifier<EmulationFocusState> {
  @override
  EmulationFocusState build() => const EmulationFocusState();

  /// Records that the emulation screen is shown, with input going to the game.
  void activate() {
    state = const EmulationFocusState(isActive: true);
  }

  /// Records that the emulation screen is no longer shown.
  void deactivate() {
    state = const EmulationFocusState();
  }

  void focus(EmulationFocus focus) {
    if (!state.isActive || state.focus == focus) return;
    state = state.copyWith(focus: focus);
  }

  /// Moves the input from the game to the menu or back.
  void toggle() {
    focus(switch (state.focus) {
      EmulationFocus.game => EmulationFocus.menu,
      EmulationFocus.menu => EmulationFocus.game,
    });
  }
}
