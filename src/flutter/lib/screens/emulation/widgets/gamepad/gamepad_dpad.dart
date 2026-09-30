import 'package:flutter/widgets.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

/// The D-PAD stick, drawn with the default style of `flutter_joystick`. It sends its position as
/// [GamePadAxis.dpad].
class GamepadDPad extends StatelessWidget {
  const GamepadDPad({super.key, required this.onMoved});

  /// Called with the stick position, each of x and y from -1.0 to 1.0 and y positive upwards. It
  /// is called with (0, 0) when the stick is released.
  final void Function(double x, double y) onMoved;

  @override
  Widget build(BuildContext context) {
    return Joystick(
      period: const Duration(milliseconds: 16),
      includeInitialAnimation: false,
      listener: (details) => onMoved(details.x, -details.y),
    );
  }
}
