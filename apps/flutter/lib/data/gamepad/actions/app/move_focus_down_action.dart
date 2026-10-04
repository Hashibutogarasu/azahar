import 'package:flutter/widgets.dart';
import 'package:gamepads/gamepads.dart';

import '../../../options/translation_text.dart';
import '../gamepad_key_combo.dart';
import 'move_focus_action.dart';

/// Moves the focus to the item below. Bound to the D-pad down by default.
class MoveFocusDownAction extends MoveFocusAction {
  MoveFocusDownAction();

  @override
  String get id => 'move_focus_down';

  @override
  TranslationText get title =>
      (t) => t.settings.gamepad.actionMoveFocusDown;

  @override
  final GamepadKeyCombo defaultCombo = GamepadKeyCombo.button(
    GamepadButton.dpadDown,
  );

  @override
  TraversalDirection get direction => TraversalDirection.down;
}
