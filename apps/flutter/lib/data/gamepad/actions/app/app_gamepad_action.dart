import '../../../../screens/emulation/emulation_focus_provider.dart';
import '../gamepad_action.dart';

/// An action that operates the app itself. It is available unless controller input goes to a
/// running game.
abstract class AppGamepadAction extends GamepadAction {
  const AppGamepadAction();

  @override
  GamepadActionScope get scope => GamepadActionScope.app;

  @override
  bool isAvailable(GamepadActionContext context) =>
      !context.ref.read(emulationFocusProvider).isGameFocused;
}
