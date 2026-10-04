import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:gamepads/gamepads.dart';

import '../../../options/translation_text.dart';
import '../gamepad_action.dart';
import '../gamepad_key_combo.dart';
import 'console_button_action.dart';
import 'console_stick_action.dart';

ConsoleButtonAction _button(
  String name,
  GamePadButton button,
  TranslationText title,
  GamepadButton defaultButton,
) {
  return ConsoleButtonAction(
    id: 'console_button_$name',
    button: button,
    title: title,
    defaultCombo: GamepadKeyCombo.button(defaultButton),
  );
}

ConsoleStickAction _stick(
  String name,
  GamePadAxis axis,
  TranslationText title,
  GamepadStick defaultStick,
) {
  return ConsoleStickAction(
    id: 'console_stick_$name',
    axis: axis,
    title: title,
    defaultCombo: GamepadKeyCombo({GamepadStickInput(defaultStick)}),
  );
}

/// The controls of the console, in the order they are listed in the settings. By default a
/// standard controller maps to them by position: the face buttons to the same buttons, back to
/// SELECT, start to START, guide to HOME, the shoulders to L and R, the triggers to ZL and ZR,
/// the D-pad to the D-pad, the left stick to the Circle Pad and the right stick to the C-Stick.
final List<GamepadAction> consoleActions = [
  _button(
    'a',
    GamePadButton.a,
    (t) => t.settings.gamepad.buttonA,
    GamepadButton.a,
  ),
  _button(
    'b',
    GamePadButton.b,
    (t) => t.settings.gamepad.buttonB,
    GamepadButton.b,
  ),
  _button(
    'x',
    GamePadButton.x,
    (t) => t.settings.gamepad.buttonX,
    GamepadButton.x,
  ),
  _button(
    'y',
    GamePadButton.y,
    (t) => t.settings.gamepad.buttonY,
    GamepadButton.y,
  ),
  _button(
    'select',
    GamePadButton.select,
    (t) => t.settings.gamepad.buttonSelect,
    GamepadButton.back,
  ),
  _button(
    'start',
    GamePadButton.start,
    (t) => t.settings.gamepad.buttonStart,
    GamepadButton.start,
  ),
  _button(
    'home',
    GamePadButton.home,
    (t) => t.settings.gamepad.buttonHome,
    GamepadButton.home,
  ),
  _button(
    'l',
    GamePadButton.l,
    (t) => t.settings.gamepad.buttonL,
    GamepadButton.leftBumper,
  ),
  _button(
    'r',
    GamePadButton.r,
    (t) => t.settings.gamepad.buttonR,
    GamepadButton.rightBumper,
  ),
  _button(
    'zl',
    GamePadButton.zl,
    (t) => t.settings.gamepad.buttonZl,
    GamepadButton.leftTrigger,
  ),
  _button(
    'zr',
    GamePadButton.zr,
    (t) => t.settings.gamepad.buttonZr,
    GamepadButton.rightTrigger,
  ),
  _button(
    'up',
    GamePadButton.up,
    (t) => t.settings.gamepad.buttonUp,
    GamepadButton.dpadUp,
  ),
  _button(
    'down',
    GamePadButton.down,
    (t) => t.settings.gamepad.buttonDown,
    GamepadButton.dpadDown,
  ),
  _button(
    'left',
    GamePadButton.left,
    (t) => t.settings.gamepad.buttonLeft,
    GamepadButton.dpadLeft,
  ),
  _button(
    'right',
    GamePadButton.right,
    (t) => t.settings.gamepad.buttonRight,
    GamepadButton.dpadRight,
  ),
  _stick(
    'circle_pad',
    GamePadAxis.dpad,
    (t) => t.settings.gamepad.circlePad,
    GamepadStick.left,
  ),
  _stick(
    'c_stick',
    GamePadAxis.cStick,
    (t) => t.settings.gamepad.cStick,
    GamepadStick.right,
  ),
];
