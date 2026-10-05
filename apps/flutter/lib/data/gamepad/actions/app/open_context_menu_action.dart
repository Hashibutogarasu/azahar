import 'package:flutter/widgets.dart';
import 'package:gamepads/gamepads.dart';

import '../../../../widgets/gamepad/gamepad_intents.dart';
import '../../../options/translation_text.dart';
import '../gamepad_action.dart';
import '../gamepad_key_combo.dart';
import 'app_gamepad_action.dart';

/// Opens the menu of the focused item, such as the one behind its three-dot button. Bound to the
/// Options (Start) button by default.
class OpenContextMenuAction extends AppGamepadAction {
  OpenContextMenuAction();

  @override
  String get id => 'open_context_menu';

  @override
  TranslationText get title =>
      (t) => t.settings.gamepad.actionOpenContextMenu;

  @override
  final GamepadKeyCombo defaultCombo = GamepadKeyCombo.button(
    GamepadButton.start,
  );

  @override
  void tick(GamepadActionContext context, GamepadComboState state) {
    if (!state.justPressed) return;
    final focusContext = context.primaryFocus?.context;
    if (focusContext == null || !focusContext.mounted) return;
    Actions.maybeInvoke(focusContext, const OpenContextMenuIntent());
  }
}
