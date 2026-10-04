import 'package:flutter/widgets.dart';
import 'package:gamepads/gamepads.dart';

import '../../../options/translation_text.dart';
import '../gamepad_key_combo.dart';
import 'move_focus_action.dart';

/// Moves the focus to the item on the left. Bound to the D-pad left by default.
class MoveFocusLeftAction extends MoveFocusAction {
  MoveFocusLeftAction();

  @override
  String get id => 'move_focus_left';

  @override
  TranslationText get title =>
      (t) => t.settings.gamepad.actionMoveFocusLeft;

  @override
  final GamepadKeyCombo defaultCombo = GamepadKeyCombo.button(
    GamepadButton.dpadLeft,
  );

  @override
  TraversalDirection get direction => TraversalDirection.left;
}
