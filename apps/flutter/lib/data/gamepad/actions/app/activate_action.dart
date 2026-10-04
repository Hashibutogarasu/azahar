import 'package:flutter/widgets.dart';
import 'package:gamepads/gamepads.dart';

import '../../../options/translation_text.dart';
import '../gamepad_action.dart';
import '../gamepad_key_combo.dart';
import 'app_gamepad_action.dart';

/// Activates the focused item, as tapping it would. Bound to A by default.
class ActivateAction extends AppGamepadAction {
  ActivateAction();

  @override
  String get id => 'activate';

  @override
  TranslationText get title =>
      (t) => t.settings.gamepad.actionActivate;

  @override
  final GamepadKeyCombo defaultCombo = GamepadKeyCombo.button(GamepadButton.a);

  @override
  void tick(GamepadActionContext context, GamepadComboState state) {
    if (!state.justPressed) return;
    final focusContext = context.primaryFocus?.context;
    if (focusContext == null || !focusContext.mounted) return;
    Actions.maybeInvoke(focusContext, const ActivateIntent());
  }
}
