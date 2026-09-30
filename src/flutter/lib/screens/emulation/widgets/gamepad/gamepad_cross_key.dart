import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';

/// The cross-shaped key with an up, down, left and right button, each a square-cornered
/// [FilledButton] in the theme's default style that presses the button of the same name.
///
/// The whole cross is one touch area, so a finger that stays down and slides from one direction to
/// another releases the first button and presses the second one.
class GamepadCrossKey extends StatefulWidget {
  const GamepadCrossKey({super.key, required this.onButton});

  final void Function(GamePadButton button, bool pressed) onButton;

  static const double _arrowSize = 40;

  @override
  State<GamepadCrossKey> createState() => _GamepadCrossKeyState();
}

class _GamepadCrossKeyState extends State<GamepadCrossKey> {
  static const _directions = [
    GamePadButton.up,
    GamePadButton.down,
    GamePadButton.left,
    GamePadButton.right,
  ];

  final Map<GamePadButton, WidgetStatesController> _controllers = {
    for (final direction in _directions) direction: WidgetStatesController(),
  };
  final Map<int, GamePadButton> _pointers = {};
  final Set<GamePadButton> _pressed = {};

  GamePadButton? _directionAt(Offset position, Size size) {
    final offset = position - size.center(Offset.zero);
    if (offset.distance < size.shortestSide / 6) return null;
    if (offset.dx.abs() > offset.dy.abs()) {
      return offset.dx < 0 ? GamePadButton.left : GamePadButton.right;
    }
    return offset.dy < 0 ? GamePadButton.up : GamePadButton.down;
  }

  void _track(int pointer, Offset position, Size size) {
    final direction = _directionAt(position, size);
    if (direction == null) {
      _pointers.remove(pointer);
    } else {
      _pointers[pointer] = direction;
    }
    _sync();
  }

  void _release(int pointer) {
    _pointers.remove(pointer);
    _sync();
  }

  void _sync() {
    final next = _pointers.values.toSet();
    for (final direction in _pressed.difference(next)) {
      _controllers[direction]!.update(WidgetState.pressed, false);
      widget.onButton(direction, false);
    }
    for (final direction in next.difference(_pressed)) {
      _controllers[direction]!.update(WidgetState.pressed, true);
      widget.onButton(direction, true);
    }
    _pressed
      ..clear()
      ..addAll(next);
  }

  @override
  void dispose() {
    _pointers.clear();
    for (final direction in _pressed) {
      widget.onButton(direction, false);
    }
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _arrow(GamePadButton direction, IconData icon) {
    return IgnorePointer(
      child: FilledButton(
        onPressed: () {},
        statesController: _controllers[direction],
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(),
          padding: EdgeInsets.zero,
          fixedSize: const Size.square(GamepadCrossKey._arrowSize),
          minimumSize: Size.zero,
        ),
        child: Icon(icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (event) =>
              _track(event.pointer, event.localPosition, size),
          onPointerMove: (event) =>
              _track(event.pointer, event.localPosition, size),
          onPointerUp: (event) => _release(event.pointer),
          onPointerCancel: (event) => _release(event.pointer),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: _arrow(GamePadButton.up, Icons.keyboard_arrow_up),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: _arrow(GamePadButton.left, Icons.keyboard_arrow_left),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: _arrow(GamePadButton.right, Icons.keyboard_arrow_right),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _arrow(GamePadButton.down, Icons.keyboard_arrow_down),
              ),
            ],
          ),
        );
      },
    );
  }
}
