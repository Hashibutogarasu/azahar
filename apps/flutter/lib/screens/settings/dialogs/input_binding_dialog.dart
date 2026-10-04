import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamepads/gamepads.dart';

import '../../../data/gamepad/actions/gamepad_key_combo.dart';
import '../../../data/options/input_binding_mode.dart';
import '../../../i18n/translations.g.dart';
import '../../../widgets/dialog_cancel_button.dart';

/// Waits for controller input and pops what it binds, as [mode] describes: the raw key of the
/// next button pressed, the key combination of everything held until it is all released, or the
/// next stick moved.
class InputBindingDialog extends StatefulWidget {
  const InputBindingDialog({
    super.key,
    required this.title,
    this.mode = InputBindingMode.rawKey,
  });

  final String title;
  final InputBindingMode mode;

  static Future<String?> show(
    BuildContext context, {
    required String title,
    InputBindingMode mode = InputBindingMode.rawKey,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => InputBindingDialog(title: title, mode: mode),
    );
  }

  @override
  State<InputBindingDialog> createState() => _InputBindingDialogState();
}

class _InputBindingDialogState extends State<InputBindingDialog> {
  StreamSubscription<Object>? _subscription;
  final Set<GamepadButton> _buttons = {};
  final Map<GamepadAxis, double> _axes = {};
  final Set<GamepadInput> _recorded = {};

  @override
  void initState() {
    super.initState();
    _subscription = switch (widget.mode) {
      InputBindingMode.rawKey =>
        Gamepads.events
            .where((event) => event.type == KeyType.button && event.value > 0.5)
            .listen((event) => _pop(event.key)),
      InputBindingMode.combo => Gamepads.normalizedEvents.listen(_onCombo),
      InputBindingMode.stick => Gamepads.normalizedEvents.listen(_onStick),
    };
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _pop(String value) {
    _subscription?.cancel();
    _subscription = null;
    if (mounted) Navigator.of(context).pop(value);
  }

  GamepadInputSnapshot _update(NormalizedGamepadEvent event) {
    final button = event.button;
    final axis = event.axis;
    if (button != null) {
      if (event.value != 0) {
        _buttons.add(button);
      } else {
        _buttons.remove(button);
      }
    } else if (axis != null) {
      _axes[axis] = event.value;
    }
    return GamepadInputSnapshot(buttons: {..._buttons}, axes: {..._axes});
  }

  void _onCombo(NormalizedGamepadEvent event) {
    final snapshot = _update(event);
    final held = <GamepadInput>{
      for (final button in snapshot.buttons) GamepadButtonInput(button),
      for (final axis in GamepadAxis.values)
        for (final positive in const [true, false])
          if (GamepadAxisDirectionInput(axis, positive: positive)
              case final input when input.isActive(snapshot))
            _triggerAsButton(axis) ?? input,
    };
    if (held.isNotEmpty) {
      setState(() => _recorded.addAll(held));
    } else if (_recorded.isNotEmpty) {
      _pop(GamepadKeyCombo({..._recorded}).serialize());
    }
  }

  GamepadInput? _triggerAsButton(GamepadAxis axis) => switch (axis) {
    GamepadAxis.leftTrigger => const GamepadButtonInput(
      GamepadButton.leftTrigger,
    ),
    GamepadAxis.rightTrigger => const GamepadButtonInput(
      GamepadButton.rightTrigger,
    ),
    _ => null,
  };

  void _onStick(NormalizedGamepadEvent event) {
    final snapshot = _update(event);
    for (final stick in GamepadStick.values) {
      if (snapshot.stickValue(stick).distance >=
          GamepadAxisDirectionInput.threshold) {
        _pop(GamepadKeyCombo({GamepadStickInput(stick)}).serialize());
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AlertDialog(
      title: Text(widget.title),
      content: Text(
        _recorded.isEmpty
            ? t.settings.inputBindingDialog.waitingForInput
            : GamepadKeyCombo({..._recorded}).label,
      ),
      actions: const [DialogCancelButton()],
    );
  }
}
