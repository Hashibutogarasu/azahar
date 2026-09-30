import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../i18n/translations.g.dart';
import 'gamepad_button.dart';

/// The SELECT, HOME and START buttons in a row, each a wide rectangle with square corners.
class GamepadMenuButtons extends StatelessWidget {
  const GamepadMenuButtons({super.key, required this.onButton});

  final void Function(GamePadButton button, bool pressed) onButton;

  @override
  Widget build(BuildContext context) {
    final buttons = context.t.emulation.gamepad.buttons;
    Widget button(String label, GamePadButton value) => GamepadButton(
      label: label,
      shape: GamepadButtonShape.rectangle,
      width: 88,
      height: 32,
      onChanged: (pressed) => onButton(value, pressed),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        button(buttons.select, GamePadButton.select),
        button(buttons.home, GamePadButton.home),
        button(buttons.start, GamePadButton.start),
      ],
    );
  }
}
