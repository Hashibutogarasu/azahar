import 'package:flutter/widgets.dart';
import 'package:gamepads/gamepads.dart';

import '../../../options/translation_text.dart';
import '../gamepad_key_combo.dart';
import 'move_focus_action.dart';

/// Moves the focus to the item on the right. Bound to the D-pad right by default.
class MoveFocusRightAction extends MoveFocusAction {
  MoveFocusRightAction();

  @override
  String get id => 'move_focus_right';

  @override
  TranslationText get title =>
      (t) => t.settings.gamepad.actionMoveFocusRight;

  @override
  final GamepadKeyCombo defaultCombo = GamepadKeyCombo.button(
    GamepadButton.dpadRight,
  );

  @override
  TraversalDirection get direction => TraversalDirection.right;
}
