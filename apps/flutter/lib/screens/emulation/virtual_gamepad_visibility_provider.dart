import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/gamepad/gamepad_hub.dart';

/// Whether the on-screen controller of the emulation is shown.
final virtualGamepadVisibleProvider =
    NotifierProvider.autoDispose<VirtualGamepadVisibilityNotifier, bool>(
      VirtualGamepadVisibilityNotifier.new,
    );

/// Hides the on-screen controller as soon as a physical controller is used, and keeps it hidden
/// until [show] is called from the in-game menu, after which it stays shown.
class VirtualGamepadVisibilityNotifier extends Notifier<bool> {
  bool _shownExplicitly = false;

  @override
  bool build() {
    ref.listen(gamepadInputModeProvider, (_, mode) {
      if (mode == GamepadInputMode.controller && !_shownExplicitly) {
        state = false;
      }
    });
    return ref.read(gamepadInputModeProvider) != GamepadInputMode.controller;
  }

  /// Shows the on-screen controller again and stops hiding it on controller input.
  void show() {
    _shownExplicitly = true;
    state = true;
  }
}
