import 'package:flutter/widgets.dart';
import 'package:gamepads/gamepads.dart';

import '../../../options/translation_text.dart';
import '../gamepad_key_combo.dart';
import 'move_focus_action.dart';

/// Moves the focus to the item above. Bound to the D-pad up by default.
class MoveFocusUpAction extends MoveFocusAction {
  MoveFocusUpAction();

  @override
  String get id => 'move_focus_up';

  @override
  TranslationText get title =>
      (t) => t.settings.gamepad.actionMoveFocusUp;

  @override
  final GamepadKeyCombo defaultCombo = GamepadKeyCombo.button(
    GamepadButton.dpadUp,
  );

  @override
  TraversalDirection get direction => TraversalDirection.up;
}
