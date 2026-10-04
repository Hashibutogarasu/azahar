import '../../../../screens/emulation/emulation_focus_provider.dart';
import '../../shell_navigation_provider.dart';
import '../gamepad_action.dart';
import '../gamepad_key_combo.dart';
import 'app_gamepad_action.dart';

/// Moves to a neighboring tab of the bottom navigation or the sidebar when its combination is
/// pressed. It is available while the Games/Options shell is shown and no game runs.
abstract class PageAction extends AppGamepadAction {
  const PageAction();

  int get offset;

  @override
  bool isAvailable(GamepadActionContext context) =>
      !context.ref.read(emulationFocusProvider).isActive &&
      context.ref.read(shellNavigationProvider).isAttached;

  @override
  void tick(GamepadActionContext context, GamepadComboState state) {
    if (!state.justPressed) return;
    context.ref.read(shellNavigationProvider).moveBy(offset);
  }
}
