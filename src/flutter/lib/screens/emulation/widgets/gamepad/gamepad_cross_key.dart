import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/widgets.dart';

import 'gamepad_layout.dart';

/// The cross key, drawn from the images of the original Android app, that presses the up, down,
/// left and right buttons.
///
/// A finger that touches down on it is followed until it lifts off, even when it leaves the key,
/// and the directions are read again as it slides, so it can move from one direction to another
/// without lifting. A direction counts as pressed once the finger is past half way from the
/// centre towards the edge, and two neighbouring directions can be pressed at once.
class GamepadCrossKey extends StatefulWidget {
  const GamepadCrossKey({super.key, required this.onButton});

  final void Function(GamePadButton button, bool pressed) onButton;

  static const double _deadZone = 0.5;

  @override
  State<GamepadCrossKey> createState() => _GamepadCrossKeyState();
}

class _GamepadCrossKeyState extends State<GamepadCrossKey> {
  int? _pointer;
  Set<GamePadButton> _pressed = {};

  void _update(Offset position, Size size) {
    final half = size.center(Offset.zero);
    final x = (position.dx - half.dx) / half.dx;
    final y = (position.dy - half.dy) / half.dy;
    final next = <GamePadButton>{
      if (y < -GamepadCrossKey._deadZone) GamePadButton.up,
      if (y > GamepadCrossKey._deadZone) GamePadButton.down,
      if (x < -GamepadCrossKey._deadZone) GamePadButton.left,
      if (x > GamepadCrossKey._deadZone) GamePadButton.right,
    };
    for (final button in _pressed.difference(next)) {
      widget.onButton(button, false);
    }
    for (final button in next.difference(_pressed)) {
      widget.onButton(button, true);
    }
    setState(() => _pressed = next);
  }

  void _release(PointerEvent event) {
    if (_pointer != event.pointer) return;
    _pointer = null;
    for (final button in _pressed) {
      widget.onButton(button, false);
    }
    setState(() => _pressed = {});
  }

  @override
  void dispose() {
    for (final button in _pressed) {
      widget.onButton(button, false);
    }
    super.dispose();
  }

  int get _quarterTurns {
    final up = _pressed.contains(GamePadButton.up);
    final down = _pressed.contains(GamePadButton.down);
    final left = _pressed.contains(GamePadButton.left);
    final right = _pressed.contains(GamePadButton.right);
    if (_pressed.length == 1) {
      if (right) return 1;
      if (down) return 2;
      if (left) return 3;
      return 0;
    }
    if (up && right) return 1;
    if (down && right) return 2;
    if (down && left) return 3;
    return 0;
  }

  String get _image {
    if (_pressed.isEmpty) return 'dpad';
    return _pressed.length == 1
        ? 'dpad_pressed_one_direction'
        : 'dpad_pressed_two_directions';
  }

  @override
  Widget build(BuildContext context) {
    final rect = GamepadLayoutScope.of(context).rectOf(GamepadControl.cross);
    return Positioned.fromRect(
      rect: rect,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          if (_pointer != null) return;
          _pointer = event.pointer;
          _update(event.localPosition, rect.size);
        },
        onPointerMove: (event) {
          if (_pointer != event.pointer) return;
          _update(event.localPosition, rect.size);
        },
        onPointerUp: _release,
        onPointerCancel: _release,
        child: Opacity(
          opacity: GamepadLayout.opacity,
          child: RotatedBox(
            quarterTurns: _quarterTurns,
            child: Image.asset(
              'assets/gamepad/$_image.png',
              fit: BoxFit.fill,
              filterQuality: FilterQuality.medium,
              gaplessPlayback: true,
            ),
          ),
        ),
      ),
    );
  }
}
