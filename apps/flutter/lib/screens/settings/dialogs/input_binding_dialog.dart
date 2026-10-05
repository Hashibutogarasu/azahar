import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamepads/gamepads.dart';

import '../../../data/gamepad/actions/gamepad_action_manager.dart';
import '../../../data/gamepad/actions/gamepad_key_combo.dart';
import '../../../data/options/input_binding_mode.dart';
import '../../../i18n/translations.g.dart';
import '../../../widgets/dialog_cancel_button.dart';

/// Waits for controller or keyboard input and pops what it binds, as [mode] describes: the raw key
/// of the next controller button pressed, the key combination of every button and key held until
/// they are all released, or the next stick moved or the four keys pressed for its directions.
///
/// While it is open, the controller input does not operate the app, and the keys pressed are kept
/// to the dialog, so that a key being bound does not also close it or move the focus.
class InputBindingDialog extends ConsumerStatefulWidget {
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
  ConsumerState<InputBindingDialog> createState() => _InputBindingDialogState();
}

class _InputBindingDialogState extends ConsumerState<InputBindingDialog> {
  StreamSubscription<Object>? _subscription;
  final Set<GamepadButton> _buttons = {};
  final Map<GamepadAxis, double> _axes = {};
  final Set<LogicalKeyboardKey> _keys = {};
  final Set<GamepadInput> _recorded = {};
  final List<LogicalKeyboardKey> _stickKeys = [];
  late final GamepadActionManager _actionManager;
  bool _popped = false;

  @override
  void initState() {
    super.initState();
    _actionManager = ref.read(gamepadActionManagerProvider.notifier)
      ..beginCapture();
    _subscription = switch (widget.mode) {
      InputBindingMode.rawKey =>
        Gamepads.events
            .where((event) => event.type == KeyType.button && event.value > 0.5)
            .listen((event) => _pop(event.key)),
      InputBindingMode.combo => Gamepads.normalizedEvents.listen(_onComboEvent),
      InputBindingMode.stick => Gamepads.normalizedEvents.listen(_onStickEvent),
    };
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _actionManager.endCapture();
    super.dispose();
  }

  void _pop(String value) {
    if (_popped) return;
    _popped = true;
    _subscription?.cancel();
    _subscription = null;
    if (mounted) Navigator.of(context).pop(value);
  }

  GamepadInputSnapshot get _snapshot => GamepadInputSnapshot(
    buttons: {..._buttons},
    axes: {..._axes},
    keys: {..._keys},
  );

  void _update(NormalizedGamepadEvent event) {
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
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (widget.mode == InputBindingMode.rawKey) return KeyEventResult.ignored;
    if (event is KeyDownEvent) {
      _keys.add(event.logicalKey);
      if (widget.mode == InputBindingMode.stick) {
        _onStickKey(event.logicalKey);
      } else {
        _recordCombo();
      }
    } else if (event is KeyUpEvent) {
      _keys.remove(event.logicalKey);
      if (widget.mode == InputBindingMode.combo) _recordCombo();
    }
    return KeyEventResult.handled;
  }

  void _onComboEvent(NormalizedGamepadEvent event) {
    _update(event);
    _recordCombo();
  }

  void _recordCombo() {
    final snapshot = _snapshot;
    final held = <GamepadInput>{
      for (final button in snapshot.buttons) GamepadButtonInput(button),
      for (final key in snapshot.keys) KeyboardKeyInput(key),
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

  void _onStickEvent(NormalizedGamepadEvent event) {
    _update(event);
    final snapshot = _snapshot;
    for (final stick in GamepadStick.values) {
      if (snapshot.stickValue(stick).distance >=
          GamepadAxisDirectionInput.threshold) {
        _pop(GamepadKeyCombo({GamepadStickInput(stick)}).serialize());
        return;
      }
    }
  }

  void _onStickKey(LogicalKeyboardKey key) {
    if (_stickKeys.contains(key)) return;
    setState(() => _stickKeys.add(key));
    if (_stickKeys.length < 4) return;
    _pop(
      GamepadKeyCombo({
        KeyboardStickInput(
          up: _stickKeys[0],
          down: _stickKeys[1],
          left: _stickKeys[2],
          right: _stickKeys[3],
        ),
      }).serialize(),
    );
  }

  String _message(Translations t) {
    final dialog = t.settings.inputBindingDialog;
    return switch (widget.mode) {
      InputBindingMode.rawKey => dialog.waitingForInput,
      InputBindingMode.combo =>
        _recorded.isEmpty
            ? dialog.waitingForComboInput
            : GamepadKeyCombo({..._recorded}).label,
      InputBindingMode.stick => switch (_stickKeys.length) {
        0 => dialog.waitingForStickInput,
        1 => dialog.pressKeyForDown,
        2 => dialog.pressKeyForLeft,
        _ => dialog.pressKeyForRight,
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: _onKey,
      child: AlertDialog(
        title: Text(widget.title),
        content: Text(_message(context.t)),
        actions: const [DialogCancelButton()],
      ),
    );
  }
}
