import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gamepads/gamepads.dart';

/// One of the two analog sticks of a controller.
enum GamepadStick {
  left(GamepadAxis.leftStickX, GamepadAxis.leftStickY),
  right(GamepadAxis.rightStickX, GamepadAxis.rightStickY);

  const GamepadStick(this.xAxis, this.yAxis);

  final GamepadAxis xAxis;
  final GamepadAxis yAxis;
}

/// The state of every input of the connected controllers at one moment. A trigger pushed past
/// [GamepadButtonInput.triggerThreshold] also counts as its button, since some platforms report
/// triggers only as axes.
class GamepadInputSnapshot {
  const GamepadInputSnapshot({required this.buttons, required this.axes});

  static const empty = GamepadInputSnapshot(buttons: {}, axes: {});

  final Set<GamepadButton> buttons;

  final Map<GamepadAxis, double> axes;

  double axis(GamepadAxis axis) => axes[axis] ?? 0;

  /// The position of [stick], with x positive to the right and y positive upwards.
  Offset stickValue(GamepadStick stick) =>
      Offset(axis(stick.xAxis), axis(stick.yAxis));

  bool get isIdle =>
      buttons.isEmpty &&
      axes.values.every((value) => value.abs() < GamepadStickInput.deadZone);
}

/// One input a key combination is made of.
sealed class GamepadInput {
  const GamepadInput();

  /// Reads an input written by [serialize], or returns null if [value] is not one.
  static GamepadInput? parse(String value) {
    final parts = value.split(':');
    switch (parts) {
      case ['button', final name]:
        final button = GamepadButton.values.asNameMap()[name];
        return button == null ? null : GamepadButtonInput(button);
      case ['axis', final name, final sign]:
        final axis = GamepadAxis.values.asNameMap()[name];
        if (axis == null || (sign != '+' && sign != '-')) return null;
        return GamepadAxisDirectionInput(axis, positive: sign == '+');
      case ['stick', final name]:
        final stick = GamepadStick.values.asNameMap()[name];
        return stick == null ? null : GamepadStickInput(stick);
      default:
        return null;
    }
  }

  /// Writes this input as text that [parse] reads back.
  String serialize();

  String get label;

  /// Whether this input is held in [snapshot].
  bool isActive(GamepadInputSnapshot snapshot);
}

/// A button, held while it is pressed.
final class GamepadButtonInput extends GamepadInput {
  const GamepadButtonInput(this.button);

  static const double triggerThreshold = 0.5;

  final GamepadButton button;

  @override
  String serialize() => 'button:${button.name}';

  @override
  String get label => switch (button) {
    GamepadButton.a => 'A',
    GamepadButton.b => 'B',
    GamepadButton.x => 'X',
    GamepadButton.y => 'Y',
    GamepadButton.leftBumper => 'LB',
    GamepadButton.rightBumper => 'RB',
    GamepadButton.leftTrigger => 'LT',
    GamepadButton.rightTrigger => 'RT',
    GamepadButton.back => 'Back',
    GamepadButton.start => 'Start',
    GamepadButton.home => 'Home',
    GamepadButton.leftStick => 'LS',
    GamepadButton.rightStick => 'RS',
    GamepadButton.dpadUp => 'D-Pad ↑',
    GamepadButton.dpadDown => 'D-Pad ↓',
    GamepadButton.dpadLeft => 'D-Pad ←',
    GamepadButton.dpadRight => 'D-Pad →',
    GamepadButton.touchpad => 'Touchpad',
  };

  @override
  bool isActive(GamepadInputSnapshot snapshot) =>
      snapshot.buttons.contains(button);

  @override
  bool operator ==(Object other) =>
      other is GamepadButtonInput && other.button == button;

  @override
  int get hashCode => Object.hash(GamepadButtonInput, button);
}

/// One direction of an axis, such as the right stick pushed to the left, held while the axis is
/// pushed past [threshold] that way.
final class GamepadAxisDirectionInput extends GamepadInput {
  const GamepadAxisDirectionInput(this.axis, {required this.positive});

  static const double threshold = 0.5;

  final GamepadAxis axis;

  final bool positive;

  @override
  String serialize() => 'axis:${axis.name}:${positive ? '+' : '-'}';

  @override
  String get label => switch ((axis, positive)) {
    (GamepadAxis.leftStickX, true) => 'LS →',
    (GamepadAxis.leftStickX, false) => 'LS ←',
    (GamepadAxis.leftStickY, true) => 'LS ↑',
    (GamepadAxis.leftStickY, false) => 'LS ↓',
    (GamepadAxis.rightStickX, true) => 'RS →',
    (GamepadAxis.rightStickX, false) => 'RS ←',
    (GamepadAxis.rightStickY, true) => 'RS ↑',
    (GamepadAxis.rightStickY, false) => 'RS ↓',
    (GamepadAxis.leftTrigger, _) => 'LT',
    (GamepadAxis.rightTrigger, _) => 'RT',
  };

  @override
  bool isActive(GamepadInputSnapshot snapshot) {
    final value = snapshot.axis(axis);
    return positive ? value >= threshold : value <= -threshold;
  }

  @override
  bool operator ==(Object other) =>
      other is GamepadAxisDirectionInput &&
      other.axis == axis &&
      other.positive == positive;

  @override
  int get hashCode => Object.hash(GamepadAxisDirectionInput, axis, positive);
}

/// A whole stick used as an analog input, held while it is outside the [deadZone].
final class GamepadStickInput extends GamepadInput {
  const GamepadStickInput(this.stick);

  static const double deadZone = 0.15;

  final GamepadStick stick;

  @override
  String serialize() => 'stick:${stick.name}';

  @override
  String get label => switch (stick) {
    GamepadStick.left => 'LS',
    GamepadStick.right => 'RS',
  };

  @override
  bool isActive(GamepadInputSnapshot snapshot) =>
      snapshot.stickValue(stick).distance >= deadZone;

  @override
  bool operator ==(Object other) =>
      other is GamepadStickInput && other.stick == stick;

  @override
  int get hashCode => Object.hash(GamepadStickInput, stick);
}

/// The inputs that have to be held together to trigger an action, such as L and A.
@immutable
class GamepadKeyCombo {
  const GamepadKeyCombo(this.inputs);

  static const none = GamepadKeyCombo({});

  /// A combination of the single [button].
  GamepadKeyCombo.button(GamepadButton button)
    : inputs = {GamepadButtonInput(button)};

  /// Reads a combination written by [serialize], leaving out the inputs it does not know.
  factory GamepadKeyCombo.parse(String value) {
    if (value.isEmpty) return none;
    return GamepadKeyCombo({
      for (final part in value.split('+')) ?GamepadInput.parse(part),
    });
  }

  final Set<GamepadInput> inputs;

  bool get isEmpty => inputs.isEmpty;

  /// Writes this combination as text that [GamepadKeyCombo.parse] reads back.
  String serialize() => inputs.map((input) => input.serialize()).join('+');

  String get label => inputs.map((input) => input.label).join(' + ');

  /// Whether every input of this combination is held in [snapshot].
  bool isActive(GamepadInputSnapshot snapshot) =>
      inputs.isNotEmpty && inputs.every((input) => input.isActive(snapshot));

  /// Whether [other] is made of some, but not all, of the inputs of this combination.
  bool strictlyContains(GamepadKeyCombo other) =>
      other.inputs.length < inputs.length && inputs.containsAll(other.inputs);

  GamepadStick? get stick {
    for (final input in inputs) {
      if (input is GamepadStickInput) return input.stick;
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      other is GamepadKeyCombo && setEquals(other.inputs, inputs);

  @override
  int get hashCode => Object.hashAllUnordered(inputs);
}

/// How the key combination of one action stands at one tick of the manager.
class GamepadComboState {
  const GamepadComboState({
    required this.combo,
    required this.isPressed,
    required this.justPressed,
    required this.justReleased,
    required this.heldDuration,
  });

  final GamepadKeyCombo combo;

  final bool isPressed;

  final bool justPressed;

  final bool justReleased;

  final Duration heldDuration;
}
