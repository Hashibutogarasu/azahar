import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../../options/translation_text.dart';
import '../gamepad_action.dart';
import '../gamepad_key_combo.dart';
import 'console_action.dart';

/// Holds [button] of the console down while its combination is held.
class ConsoleButtonAction extends ConsoleAction {
  const ConsoleButtonAction({
    required this.id,
    required this.button,
    required this.title,
    required this.defaultCombo,
  });

  @override
  final String id;

  final GamePadButton button;

  @override
  final TranslationText title;

  @override
  final GamepadKeyCombo defaultCombo;

  @override
  void tick(GamepadActionContext context, GamepadComboState state) {
    if (!state.justPressed && !state.justReleased) return;
    sendToSession(
      context,
      (session) =>
          session.sendGamePadButton(button, pressed: state.justPressed),
    );
  }
}
