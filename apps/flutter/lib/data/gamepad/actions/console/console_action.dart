import '../../../../screens/emulation/emulation_focus_provider.dart';
import '../../../../screens/emulation/emulation_session_provider.dart';
import '../gamepad_action.dart';

/// An action that operates one control of the console. It is available while a game runs, is not
/// paused, and controller input goes to it.
abstract class ConsoleAction extends GamepadAction {
  const ConsoleAction();

  @override
  GamepadActionScope get scope => GamepadActionScope.emulation;

  @override
  bool isAvailable(GamepadActionContext context) {
    if (!context.ref.read(emulationFocusProvider).isGameFocused) return false;
    final session = context.ref.read(emulationSessionProvider);
    return session.emulationStarted && !session.isPaused;
  }

  /// Hands the emulation session to [send], unless the emulation screen is already gone.
  void sendToSession(
    GamepadActionContext context,
    void Function(EmulationSessionNotifier session) send,
  ) {
    if (!context.ref.read(emulationFocusProvider).isActive) return;
    send(context.ref.read(emulationSessionProvider.notifier));
  }
}
