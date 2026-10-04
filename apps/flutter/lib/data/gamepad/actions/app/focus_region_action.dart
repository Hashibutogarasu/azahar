import '../../../../widgets/gamepad/gamepad_focus_region.dart';
import '../gamepad_action.dart';
import '../gamepad_key_combo.dart';
import 'app_gamepad_action.dart';

/// Moves the focus to a neighboring [GamepadFocusRegion] when its combination is pressed.
abstract class FocusRegionAction extends AppGamepadAction {
  const FocusRegionAction();

  int get offset;

  @override
  void tick(GamepadActionContext context, GamepadComboState state) {
    if (state.justPressed) GamepadFocusRegion.moveFocusBy(offset);
  }
}
