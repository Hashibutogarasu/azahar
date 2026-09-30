import 'dart:async';

import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_gamepad/universal_gamepad.dart' as physical;

import 'emulation_session_provider.dart';

/// Gives the input of physical game controllers to the emulation, as the buttons and sticks of
/// the console. It draws nothing.
///
/// The controller layout follows the standard gamepad: A, B, X and Y map to the same buttons of
/// the console, back to SELECT, start to START, guide to HOME, the shoulders to L and R, the
/// triggers to ZL and ZR, the D-pad to the D-PAD, the left stick to the Circle Pad and the right
/// stick to the C-Stick.
class PhysicalGamepadSource extends ConsumerStatefulWidget {
  const PhysicalGamepadSource({super.key, required this.child});

  final Widget child;

  /// The console button a controller button stands for, or null if it has no counterpart.
  @visibleForTesting
  static GamePadButton? buttonFor(physical.GamepadButton button) {
    return switch (button) {
      physical.GamepadButton.a => GamePadButton.a,
      physical.GamepadButton.b => GamePadButton.b,
      physical.GamepadButton.x => GamePadButton.x,
      physical.GamepadButton.y => GamePadButton.y,
      physical.GamepadButton.back => GamePadButton.select,
      physical.GamepadButton.start => GamePadButton.start,
      physical.GamepadButton.guide => GamePadButton.home,
      physical.GamepadButton.leftShoulder => GamePadButton.l,
      physical.GamepadButton.rightShoulder => GamePadButton.r,
      physical.GamepadButton.leftTrigger => GamePadButton.zl,
      physical.GamepadButton.rightTrigger => GamePadButton.zr,
      physical.GamepadButton.dpadUp => GamePadButton.up,
      physical.GamepadButton.dpadDown => GamePadButton.down,
      physical.GamepadButton.dpadLeft => GamePadButton.left,
      physical.GamepadButton.dpadRight => GamePadButton.right,
      physical.GamepadButton.leftStickButton ||
      physical.GamepadButton.rightStickButton => null,
    };
  }

  @override
  ConsumerState<PhysicalGamepadSource> createState() =>
      _PhysicalGamepadSourceState();
}

class _PhysicalGamepadSourceState extends ConsumerState<PhysicalGamepadSource> {
  StreamSubscription<physical.GamepadButtonEvent>? _buttonSubscription;
  StreamSubscription<physical.GamepadAxisEvent>? _axisSubscription;
  double _circleX = 0;
  double _circleY = 0;
  double _cStickX = 0;
  double _cStickY = 0;

  @override
  void initState() {
    super.initState();
    _buttonSubscription = physical.Gamepad.instance.buttonEvents.listen(
      _onButton,
      onError: (_) {},
    );
    _axisSubscription = physical.Gamepad.instance.axisEvents.listen(
      _onAxis,
      onError: (_) {},
    );
  }

  @override
  void dispose() {
    _buttonSubscription?.cancel();
    _axisSubscription?.cancel();
    super.dispose();
  }

  EmulationSessionNotifier get _session =>
      ref.read(emulationSessionProvider.notifier);

  bool get _accepting {
    final state = ref.read(emulationSessionProvider);
    return state.emulationStarted && !state.isPaused;
  }

  void _onButton(physical.GamepadButtonEvent event) {
    final button = PhysicalGamepadSource.buttonFor(event.button);
    if (button == null || !_accepting) return;
    _session.sendGamePadButton(button, pressed: event.pressed);
  }

  void _onAxis(physical.GamepadAxisEvent event) {
    if (!_accepting) return;
    switch (event.axis) {
      case physical.GamepadAxis.leftStickX:
        _circleX = event.value;
        _session.sendGamePadAxis(GamePadAxis.dpad, _circleX, -_circleY);
      case physical.GamepadAxis.leftStickY:
        _circleY = event.value;
        _session.sendGamePadAxis(GamePadAxis.dpad, _circleX, -_circleY);
      case physical.GamepadAxis.rightStickX:
        _cStickX = event.value;
        _session.sendGamePadAxis(GamePadAxis.cStick, _cStickX, -_cStickY);
      case physical.GamepadAxis.rightStickY:
        _cStickY = event.value;
        _session.sendGamePadAxis(GamePadAxis.cStick, _cStickX, -_cStickY);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
