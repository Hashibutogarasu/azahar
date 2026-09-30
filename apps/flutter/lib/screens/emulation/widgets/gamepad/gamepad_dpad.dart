import 'dart:math';

import 'package:flutter/widgets.dart';

import 'gamepad_layout.dart';

/// The D-PAD stick, drawn from the images of the original Android app: an outer ring and an inner
/// stick. It sends its position as [GamePadAxis.dpad].
///
/// When a finger touches down, the ring moves to the touched point and the stick follows the
/// finger within the ring's radius. When the finger lifts off, both return to their place and the
/// position is (0, 0).
class GamepadDPad extends StatefulWidget {
  const GamepadDPad({super.key, required this.onMoved});

  final void Function(double x, double y) onMoved;

  @override
  State<GamepadDPad> createState() => _GamepadDPadState();
}

class _GamepadDPadState extends State<GamepadDPad> {
  int? _pointer;
  Offset? _center;
  Offset _axis = Offset.zero;

  void _move(Offset position, double side) {
    final center = _center!;
    final radius = side / 2;
    var x = (position.dx - center.dx) / radius;
    var y = (position.dy - center.dy) / radius;
    final length = sqrt(x * x + y * y);
    if (length > 1) {
      x /= length;
      y /= length;
    }
    setState(() => _axis = Offset(x, y));
    widget.onMoved(x, -y);
  }

  void _release(PointerEvent event) {
    if (_pointer != event.pointer) return;
    _pointer = null;
    setState(() {
      _center = null;
      _axis = Offset.zero;
    });
    widget.onMoved(0, 0);
  }

  @override
  void dispose() {
    if (_pointer != null) widget.onMoved(0, 0);
    super.dispose();
  }

  Widget _image(String name, Offset topLeft, double side) {
    return Positioned(
      left: topLeft.dx,
      top: topLeft.dy,
      width: side,
      height: side,
      child: Opacity(
        opacity: GamepadLayout.opacity,
        child: Image.asset(
          'assets/gamepad/$name.png',
          fit: BoxFit.fill,
          filterQuality: FilterQuality.medium,
          gaplessPlayback: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rect = GamepadLayoutScope.of(
      context,
    ).rectOf(GamepadControl.circlePad);
    final side = rect.width;
    final restCenter = Offset(side / 2, side / 2);
    final center = _center ?? restCenter;
    final stickCenter = center + _axis * (side / 2);
    final pressed = _pointer != null;
    return Positioned.fromRect(
      rect: rect,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          if (_pointer != null) return;
          _pointer = event.pointer;
          _center = event.localPosition;
          _move(event.localPosition, side);
        },
        onPointerMove: (event) {
          if (_pointer != event.pointer) return;
          _move(event.localPosition, side);
        },
        onPointerUp: _release,
        onPointerCancel: _release,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _image(
              'stick_main_range',
              center - Offset(side / 2, side / 2),
              side,
            ),
            _image(
              pressed ? 'stick_main_pressed' : 'stick_main',
              stickCenter - Offset(side / 2, side / 2),
              side,
            ),
          ],
        ),
      ),
    );
  }
}
