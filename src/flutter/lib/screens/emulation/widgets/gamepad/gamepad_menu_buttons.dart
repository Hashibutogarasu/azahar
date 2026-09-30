import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/widgets.dart';

import 'gamepad_button.dart';
import 'gamepad_layout.dart';

/// The SELECT and START buttons, each a [GamepadButton]. The original Android app shows no HOME
/// button by default, and neither does this.
class GamepadMenuButtons extends StatelessWidget {
  const GamepadMenuButtons({super.key, required this.onButton});

  final void Function(GamePadButton button, bool pressed) onButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlacedGamepadButton(
          control: GamepadControl.select,
          image: 'button_select',
          button: GamePadButton.select,
          onButton: onButton,
        ),
        PlacedGamepadButton(
          control: GamepadControl.start,
          image: 'button_start',
          button: GamePadButton.start,
          onButton: onButton,
        ),
      ],
    );
  }
}
