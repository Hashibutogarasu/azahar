import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../options/translation_text.dart';
import 'gamepad_key_combo.dart';

/// Where an action is used, operating the app itself or a running game, which decides the table
/// its key combination is stored in.
enum GamepadActionScope { app, emulation }

/// What an action can see and reach while it is ticked.
class GamepadActionContext {
  const GamepadActionContext({
    required this.ref,
    required this.snapshot,
    required this.navigatorKey,
  });

  final Ref ref;

  final GamepadInputSnapshot snapshot;

  final GlobalKey<NavigatorState> navigatorKey;

  FocusNode? get primaryFocus => FocusManager.instance.primaryFocus;

  bool get isEditingText => isTextField(primaryFocus);

  /// Whether [node] is the focus of a text field.
  static bool isTextField(FocusNode? node) {
    final nodeContext = node?.context;
    if (nodeContext == null || !nodeContext.mounted) return false;
    return nodeContext.widget is EditableText ||
        nodeContext.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  NavigatorState? get navigator {
    final focusContext = primaryFocus?.context;
    if (focusContext != null && focusContext.mounted) {
      final navigator = Navigator.maybeOf(focusContext);
      if (navigator != null) return navigator;
    }
    return navigatorKey.currentState;
  }

  /// The position of [stick], with x positive to the right and y positive upwards.
  Offset stickValue(GamepadStick stick) => snapshot.stickValue(stick);
}

/// Something a controller can do, defined by what it does, the key combination it needs by
/// default and the name it is shown with.
abstract class GamepadAction {
  const GamepadAction();

  String get id;

  GamepadActionScope get scope;

  TranslationText get title;

  GamepadKeyCombo get defaultCombo;

  /// Whether the action can run in the current state of the app.
  bool isAvailable(GamepadActionContext context);

  /// Reacts to the state of the key combination at one tick. An action that stops being
  /// available while its combination is held gets one last tick with
  /// [GamepadComboState.justReleased] set.
  void tick(GamepadActionContext context, GamepadComboState state);
}
