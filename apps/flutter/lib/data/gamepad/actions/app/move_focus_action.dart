import 'package:flutter/widgets.dart';

import '../gamepad_action.dart';
import '../gamepad_key_combo.dart';
import 'app_gamepad_action.dart';

/// Moves the focus one item in [direction] when its combination is pressed, and keeps moving it
/// every [repeatInterval] once the combination has been held for [repeatDelay].
///
/// When nothing is focused yet, the first press focuses the first item of the screen that is not a
/// text field instead. When no item lies in [direction] up or down, the focus moves to the next or
/// previous item in reading order, so that it can always leave a region of one item.
abstract class MoveFocusAction extends AppGamepadAction {
  MoveFocusAction();

  static const Duration repeatDelay = Duration(milliseconds: 400);

  static const Duration repeatInterval = Duration(milliseconds: 100);

  TraversalDirection get direction;

  Duration _nextRepeat = repeatDelay;

  @override
  void tick(GamepadActionContext context, GamepadComboState state) {
    if (!state.isPressed) {
      _nextRepeat = repeatDelay;
      return;
    }
    if (state.justPressed) {
      _move(context);
      return;
    }
    if (state.heldDuration >= _nextRepeat) {
      _nextRepeat += repeatInterval;
      _move(context);
    }
  }

  void _move(GamepadActionContext context) {
    final focused = context.primaryFocus;
    if (focused == null ||
        focused.context == null ||
        focused is FocusScopeNode) {
      _focusFirst(
        focused is FocusScopeNode ? focused : FocusManager.instance.rootScope,
      );
      return;
    }
    if (focused.focusInDirection(direction)) return;
    switch (direction) {
      case TraversalDirection.down:
        focused.nextFocus();
      case TraversalDirection.up:
        focused.previousFocus();
      case TraversalDirection.left:
      case TraversalDirection.right:
        break;
    }
  }

  void _focusFirst(FocusScopeNode scope) {
    for (final node in scope.traversalDescendants) {
      if (node.canRequestFocus &&
          !node.skipTraversal &&
          !GamepadActionContext.isTextField(node)) {
        node.requestFocus();
        return;
      }
    }
    scope.nextFocus();
  }
}
