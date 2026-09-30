import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../i18n/translations.g.dart';

/// The outline of a [GamepadButton].
enum GamepadButtonShape {
  /// A circle whose diameter is the button's height.
  circle,

  /// A rectangle with square corners.
  rectangle,
}

/// One on-screen button that reports when it is pressed and released. It shows either a [label] or
/// an [icon], and takes its colors from the theme's [FilledButton].
///
/// It listens to raw pointer events, so several buttons can be held at once and a button stays
/// pressed while a finger rests on it.
class GamepadButton extends StatefulWidget {
  const GamepadButton({
    super.key,
    this.label,
    this.icon,
    required this.onChanged,
    this.shape = GamepadButtonShape.circle,
    this.width = 56,
    this.height = 56,
  }) : assert(label != null || icon != null);

  final String? label;

  final IconData? icon;

  /// Called with true when the button is pressed and false when it is released.
  final ValueChanged<bool> onChanged;

  final GamepadButtonShape shape;

  final double width;

  final double height;

  @override
  State<GamepadButton> createState() => _GamepadButtonState();
}

class _GamepadButtonState extends State<GamepadButton> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (_pressed == pressed) return;
    _pressed = pressed;
    widget.onChanged(pressed);
  }

  @override
  void dispose() {
    if (_pressed) widget.onChanged(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final OutlinedBorder shape = switch (widget.shape) {
      GamepadButtonShape.circle => const CircleBorder(),
      GamepadButtonShape.rectangle => const RoundedRectangleBorder(),
    };
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: FilledButton(
        onPressed: () {},
        style: FilledButton.styleFrom(
          shape: shape,
          padding: EdgeInsets.zero,
          fixedSize: Size(widget.width, widget.height),
          minimumSize: Size.zero,
        ),
        child: widget.icon != null ? Icon(widget.icon) : Text(widget.label!),
      ),
    );
  }
}

/// The A, B, X and Y buttons in the layout of the 3DS: X on top, Y on the left, A on the right
/// and B at the bottom. Each one is a [GamepadButton].
class GamepadFaceButtons extends StatelessWidget {
  const GamepadFaceButtons({super.key, required this.onButton});

  final void Function(GamePadButton button, bool pressed) onButton;

  static const double _buttonSize = 56;
  static const double _gap = 4;

  @override
  Widget build(BuildContext context) {
    final buttons = context.t.emulation.gamepad.buttons;
    Widget button(String label, GamePadButton value) => GamepadButton(
      label: label,
      width: _buttonSize,
      height: _buttonSize,
      onChanged: (pressed) => onButton(value, pressed),
    );
    const side = _buttonSize * 3 + _gap * 2;
    return SizedBox.square(
      dimension: side,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: button(buttons.x, GamePadButton.x),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: button(buttons.y, GamePadButton.y),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: button(buttons.a, GamePadButton.a),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: button(buttons.b, GamePadButton.b),
          ),
        ],
      ),
    );
  }
}
