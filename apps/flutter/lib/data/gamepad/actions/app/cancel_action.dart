import 'package:flutter/widgets.dart';
import 'package:gamepads/gamepads.dart';

import '../../../options/translation_text.dart';
import '../gamepad_action.dart';
import '../gamepad_key_combo.dart';
import 'app_gamepad_action.dart';

/// Leaves the focused text field, or dismisses what is open in front, such as a dialog, a menu or
/// a drawer, or goes back to the previous screen when nothing is. Bound to B by default.
class CancelAction extends AppGamepadAction {
  CancelAction();

  @override
  String get id => 'cancel';

  @override
  TranslationText get title =>
      (t) => t.settings.gamepad.actionCancel;

  @override
  final GamepadKeyCombo defaultCombo = GamepadKeyCombo.button(GamepadButton.b);

  @override
  void tick(GamepadActionContext context, GamepadComboState state) {
    if (!state.justPressed) return;
    if (context.isEditingText) {
      context.primaryFocus?.unfocus();
      return;
    }
    final focusContext = context.primaryFocus?.context;
    if (focusContext != null && focusContext.mounted) {
      const intent = DismissIntent();
      final action = Actions.maybeFind<DismissIntent>(focusContext);
      if (action != null && action.isEnabled(intent)) {
        Actions.invoke(focusContext, intent);
        return;
      }
    }
    context.navigator?.maybePop();
  }
}
