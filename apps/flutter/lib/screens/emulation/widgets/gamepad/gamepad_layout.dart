import 'package:flutter/widgets.dart';

/// The on-screen controls, in the set the original Android app shows by default: the face
/// buttons, the shoulder buttons L and R, START and SELECT, the cross key and the Circle Pad.
enum GamepadControl { a, b, x, y, l, r, start, select, cross, circlePad }

/// Where and how large each [GamepadControl] is on a screen of a given size, the way the original
/// Android app places them.
///
/// A position is the top left corner of the control, given in thousandths of the screen width and
/// height and set separately for portrait and landscape. A control is a square whose side is the
/// shorter side of the screen multiplied by the control's scale.
class GamepadLayout {
  const GamepadLayout(this.size);

  final Size size;

  static const double opacity = 127 / 255;

  static const Map<GamepadControl, _Placement> _placements = {
    GamepadControl.a: _Placement(
      landscape: Offset(930, 620),
      portrait: Offset(810, 870),
      scale: 0.11,
    ),
    GamepadControl.b: _Placement(
      landscape: Offset(870, 720),
      portrait: Offset(710, 925),
      scale: 0.11,
    ),
    GamepadControl.x: _Placement(
      landscape: Offset(870, 520),
      portrait: Offset(710, 815),
      scale: 0.11,
    ),
    GamepadControl.y: _Placement(
      landscape: Offset(810, 620),
      portrait: Offset(610, 870),
      scale: 0.11,
    ),
    GamepadControl.l: _Placement(
      landscape: Offset(13, 0),
      portrait: Offset(10, 640),
      scale: 0.18,
    ),
    GamepadControl.r: _Placement(
      landscape: Offset(895, 0),
      portrait: Offset(810, 640),
      scale: 0.18,
    ),
    GamepadControl.start: _Placement(
      landscape: Offset(550, 850),
      portrait: Offset(520, 794),
      scale: 0.08,
    ),
    GamepadControl.select: _Placement(
      landscape: Offset(470, 850),
      portrait: Offset(400, 794),
      scale: 0.08,
    ),
    GamepadControl.cross: _Placement(
      landscape: Offset(15, 470),
      portrait: Offset(10, 730),
      scale: 0.22,
    ),
    GamepadControl.circlePad: _Placement(
      landscape: Offset(100, 670),
      portrait: Offset(80, 850),
      scale: 0.275,
    ),
  };

  bool get isLandscape => size.width > size.height;

  Rect rectOf(GamepadControl control) {
    final placement = _placements[control]!;
    final position = isLandscape ? placement.landscape : placement.portrait;
    final side = size.shortestSide * placement.scale;
    return Rect.fromLTWH(
      position.dx / 1000 * size.width,
      position.dy / 1000 * size.height,
      side,
      side,
    );
  }
}

class _Placement {
  const _Placement({
    required this.landscape,
    required this.portrait,
    required this.scale,
  });

  final Offset landscape;
  final Offset portrait;
  final double scale;
}

/// Gives the controls below it the [GamepadLayout] of the area they are placed in.
class GamepadLayoutScope extends InheritedWidget {
  const GamepadLayoutScope({
    super.key,
    required this.layout,
    required super.child,
  });

  final GamepadLayout layout;

  static GamepadLayout of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GamepadLayoutScope>()!
        .layout;
  }

  @override
  bool updateShouldNotify(GamepadLayoutScope oldWidget) =>
      oldWidget.layout.size != layout.size;
}
