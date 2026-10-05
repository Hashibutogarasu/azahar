import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/gamepad/gamepad_hub.dart';
import 'emulation_focus_provider.dart';

/// Whether the on-screen controller of the emulation is shown.
final virtualGamepadVisibleProvider =
    NotifierProvider.autoDispose<VirtualGamepadVisibilityNotifier, bool>(
      VirtualGamepadVisibilityNotifier.new,
    );

/// Hides the on-screen controller whenever a physical controller operates the running game, and
/// lets the in-game menu show or hide it with [toggle].
class VirtualGamepadVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() {
    ref.listen(normalizedGamepadEventsProvider, (_, next) {
      final event = next.value;
      if (event == null || !state) return;
      if (event.value.abs() < GamepadInputModeNotifier.activationThreshold) {
        return;
      }
      if (ref.read(emulationFocusProvider).isGameFocused) state = false;
    });
    return ref.read(gamepadInputModeProvider) != GamepadInputMode.controller;
  }

  void toggle() {
    state = !state;
  }
}
