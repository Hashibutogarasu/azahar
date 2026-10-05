import 'dart:ui';

import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../../options/translation_text.dart';
import '../gamepad_action.dart';
import '../gamepad_key_combo.dart';
import 'console_action.dart';

/// Moves [axis] of the console, the Circle Pad or the C-Stick, as the stick of its combination
/// moves, and centers it when the stick is released.
class ConsoleStickAction extends ConsoleAction {
  ConsoleStickAction({
    required this.id,
    required this.axis,
    required this.title,
    required this.defaultCombo,
  });

  @override
  final String id;

  final GamePadAxis axis;

  @override
  final TranslationText title;

  @override
  final GamepadKeyCombo defaultCombo;

  Offset _sent = Offset.zero;

  @override
  void tick(GamepadActionContext context, GamepadComboState state) {
    final stick = state.combo.stick;
    final position = state.isPressed && stick != null
        ? context.stickValue(stick)
        : Offset.zero;
    if (position == _sent) return;
    _sent = position;
    sendToSession(
      context,
      (session) => session.sendGamePadAxis(axis, position.dx, position.dy),
    );
  }
}
