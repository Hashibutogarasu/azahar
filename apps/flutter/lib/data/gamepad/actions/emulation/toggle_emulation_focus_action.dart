import 'package:gamepads/gamepads.dart';

import '../../../../screens/emulation/emulation_focus_provider.dart';
import '../../../options/translation_text.dart';
import '../gamepad_action.dart';
import '../gamepad_key_combo.dart';

/// Moves controller input between the running game and the in-game menu. Bound to pressing the
/// right stick by default.
class ToggleEmulationFocusAction extends GamepadAction {
  ToggleEmulationFocusAction();

  @override
  String get id => 'toggle_emulation_focus';

  @override
  GamepadActionScope get scope => GamepadActionScope.emulation;

  @override
  TranslationText get title =>
      (t) => t.settings.gamepad.actionToggleEmulationFocus;

  @override
  final GamepadKeyCombo defaultCombo = GamepadKeyCombo.button(
    GamepadButton.rightStick,
  );

  @override
  bool isAvailable(GamepadActionContext context) =>
      context.ref.read(emulationFocusProvider).isActive;

  @override
  void tick(GamepadActionContext context, GamepadComboState state) {
    if (state.justPressed) {
      context.ref.read(emulationFocusProvider.notifier).toggle();
    }
  }
}
