import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/widgets.dart';

import 'gamepad_layout.dart';

/// One on-screen button drawn from the image of the original Android app, with a second image
/// while it is pressed.
///
/// A finger presses it by touching down on it and releases it by lifting off, wherever it has
/// moved to meanwhile. Several buttons can be held at once.
class GamepadButton extends StatefulWidget {
  const GamepadButton({
    super.key,
    required this.image,
    required this.onChanged,
  });

  final String image;

  final ValueChanged<bool> onChanged;

  @override
  State<GamepadButton> createState() => _GamepadButtonState();
}

class _GamepadButtonState extends State<GamepadButton> {
  int? _pointer;

  void _press(PointerDownEvent event) {
    if (_pointer != null) return;
    setState(() => _pointer = event.pointer);
    widget.onChanged(true);
  }

  void _release(PointerEvent event) {
    if (_pointer != event.pointer) return;
    setState(() => _pointer = null);
    widget.onChanged(false);
  }

  @override
  void dispose() {
    if (_pointer != null) widget.onChanged(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suffix = _pointer == null ? '' : '_pressed';
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _press,
      onPointerUp: _release,
      onPointerCancel: _release,
      child: Opacity(
        opacity: GamepadLayout.opacity,
        child: Image.asset(
          'assets/gamepad/${widget.image}$suffix.png',
          fit: BoxFit.fill,
          filterQuality: FilterQuality.medium,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}

/// A [GamepadButton] of the console placed where the original Android app places it.
class PlacedGamepadButton extends StatelessWidget {
  const PlacedGamepadButton({
    super.key,
    required this.control,
    required this.image,
    required this.button,
    required this.onButton,
  });

  final GamepadControl control;

  final String image;

  final GamePadButton button;

  final void Function(GamePadButton button, bool pressed) onButton;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: GamepadLayoutScope.of(context).rectOf(control),
      child: GamepadButton(
        image: image,
        onChanged: (pressed) => onButton(button, pressed),
      ),
    );
  }
}

/// The A, B, X and Y buttons, each a [GamepadButton].
class GamepadFaceButtons extends StatelessWidget {
  const GamepadFaceButtons({super.key, required this.onButton});

  final void Function(GamePadButton button, bool pressed) onButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlacedGamepadButton(
          control: GamepadControl.a,
          image: 'button_a',
          button: GamePadButton.a,
          onButton: onButton,
        ),
        PlacedGamepadButton(
          control: GamepadControl.b,
          image: 'button_b',
          button: GamePadButton.b,
          onButton: onButton,
        ),
        PlacedGamepadButton(
          control: GamepadControl.x,
          image: 'button_x',
          button: GamePadButton.x,
          onButton: onButton,
        ),
        PlacedGamepadButton(
          control: GamepadControl.y,
          image: 'button_y',
          button: GamePadButton.y,
          onButton: onButton,
        ),
      ],
    );
  }
}

/// The L and R buttons, each a [GamepadButton].
class GamepadShoulderButtons extends StatelessWidget {
  const GamepadShoulderButtons({super.key, required this.onButton});

  final void Function(GamePadButton button, bool pressed) onButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlacedGamepadButton(
          control: GamepadControl.l,
          image: 'button_l',
          button: GamePadButton.l,
          onButton: onButton,
        ),
        PlacedGamepadButton(
          control: GamepadControl.r,
          image: 'button_r',
          button: GamePadButton.r,
          onButton: onButton,
        ),
      ],
    );
  }
}
