import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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

/// The state of every input of the connected controllers and of the keyboard at one moment. A
/// trigger pushed past [GamepadButtonInput.triggerThreshold] also counts as its button, since some
/// platforms report triggers only as axes.
class GamepadInputSnapshot {
  const GamepadInputSnapshot({
    required this.buttons,
    required this.axes,
    this.keys = const {},
  });

  static const empty = GamepadInputSnapshot(buttons: {}, axes: {});

  final Set<GamepadButton> buttons;

  final Map<GamepadAxis, double> axes;

  final Set<LogicalKeyboardKey> keys;

  double axis(GamepadAxis axis) => axes[axis] ?? 0;

  /// The position of [stick], with x positive to the right and y positive upwards.
  Offset stickValue(GamepadStick stick) =>
      Offset(axis(stick.xAxis), axis(stick.yAxis));

  bool get isIdle =>
      buttons.isEmpty &&
      keys.isEmpty &&
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
      case ['key', final id]:
        final key = _keyFrom(id);
        return key == null ? null : KeyboardKeyInput(key);
      case ['keystick', final ids]:
        final keys = [for (final id in ids.split(',')) _keyFrom(id)];
        if (keys.length != 4 || keys.contains(null)) return null;
        return KeyboardStickInput(
          up: keys[0]!,
          down: keys[1]!,
          left: keys[2]!,
          right: keys[3]!,
        );
      default:
        return null;
    }
  }

  static LogicalKeyboardKey? _keyFrom(String id) {
    final keyId = int.tryParse(id);
    if (keyId == null) return null;
    return LogicalKeyboardKey.findKeyByKeyId(keyId) ??
        LogicalKeyboardKey(keyId);
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

/// A key of the keyboard, held while it is pressed.
final class KeyboardKeyInput extends GamepadInput {
  const KeyboardKeyInput(this.key);

  final LogicalKeyboardKey key;

  @override
  String serialize() => 'key:${key.keyId}';

  @override
  String get label => _keyLabel(key);

  @override
  bool isActive(GamepadInputSnapshot snapshot) => snapshot.keys.contains(key);

  @override
  bool operator ==(Object other) =>
      other is KeyboardKeyInput && other.key == key;

  @override
  int get hashCode => Object.hash(KeyboardKeyInput, key);
}

String _keyLabel(LogicalKeyboardKey key) {
  final label = key.keyLabel;
  return label.trim().isEmpty ? key.debugName ?? '${key.keyId}' : label;
}

/// An input with a position, such as a stick, which moves an analog control of the console.
sealed class GamepadAnalogInput extends GamepadInput {
  const GamepadAnalogInput();

  /// The position in [snapshot], with x positive to the right and y positive upwards, each from
  /// -1.0 to 1.0.
  Offset position(GamepadInputSnapshot snapshot);
}

/// A whole stick used as an analog input, held while it is outside the [deadZone].
final class GamepadStickInput extends GamepadAnalogInput {
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
  Offset position(GamepadInputSnapshot snapshot) => snapshot.stickValue(stick);

  @override
  bool isActive(GamepadInputSnapshot snapshot) =>
      snapshot.stickValue(stick).distance >= deadZone;

  @override
  bool operator ==(Object other) =>
      other is GamepadStickInput && other.stick == stick;

  @override
  int get hashCode => Object.hash(GamepadStickInput, stick);
}

/// Four keys of the keyboard used as a stick, each pushing it all the way in its direction, and
/// held while any of them is pressed.
final class KeyboardStickInput extends GamepadAnalogInput {
  const KeyboardStickInput({
    required this.up,
    required this.down,
    required this.left,
    required this.right,
  });

  final LogicalKeyboardKey up;
  final LogicalKeyboardKey down;
  final LogicalKeyboardKey left;
  final LogicalKeyboardKey right;

  @override
  String serialize() =>
      'keystick:${[up, down, left, right].map((key) => key.keyId).join(',')}';

  @override
  String get label => [up, down, left, right].map(_keyLabel).join('/');

  @override
  Offset position(GamepadInputSnapshot snapshot) {
    double axis(LogicalKeyboardKey negative, LogicalKeyboardKey positive) =>
        (snapshot.keys.contains(positive) ? 1.0 : 0.0) -
        (snapshot.keys.contains(negative) ? 1.0 : 0.0);
    final offset = Offset(axis(left, right), axis(down, up));
    return offset.distance > 1 ? offset / offset.distance : offset;
  }

  @override
  bool isActive(GamepadInputSnapshot snapshot) =>
      position(snapshot) != Offset.zero;

  @override
  bool operator ==(Object other) =>
      other is KeyboardStickInput &&
      other.up == up &&
      other.down == down &&
      other.left == left &&
      other.right == right;

  @override
  int get hashCode => Object.hash(KeyboardStickInput, up, down, left, right);
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

  GamepadAnalogInput? get analog {
    for (final input in inputs) {
      if (input is GamepadAnalogInput) return input;
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
