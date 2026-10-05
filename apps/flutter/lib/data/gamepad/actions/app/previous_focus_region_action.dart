import 'package:gamepads/gamepads.dart';

import '../../../options/translation_text.dart';
import '../gamepad_key_combo.dart';
import 'focus_region_action.dart';

/// Moves the focus to the previous region. Bound to the right stick pushed left by default.
class PreviousFocusRegionAction extends FocusRegionAction {
  PreviousFocusRegionAction();

  @override
  String get id => 'previous_focus_region';

  @override
  TranslationText get title =>
      (t) => t.settings.gamepad.actionPreviousFocusRegion;

  @override
  final GamepadKeyCombo defaultCombo = GamepadKeyCombo({
    const GamepadAxisDirectionInput(GamepadAxis.rightStickX, positive: false),
  });

  @override
  int get offset => -1;
}
