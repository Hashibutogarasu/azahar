import 'package:gamepads/gamepads.dart';

import '../../../options/translation_text.dart';
import '../gamepad_key_combo.dart';
import 'focus_region_action.dart';

/// Moves the focus to the next region. Bound to the right stick pushed right by default.
class NextFocusRegionAction extends FocusRegionAction {
  NextFocusRegionAction();

  @override
  String get id => 'next_focus_region';

  @override
  TranslationText get title =>
      (t) => t.settings.gamepad.actionNextFocusRegion;

  @override
  final GamepadKeyCombo defaultCombo = GamepadKeyCombo({
    const GamepadAxisDirectionInput(GamepadAxis.rightStickX, positive: true),
  });

  @override
  int get offset => 1;
}
