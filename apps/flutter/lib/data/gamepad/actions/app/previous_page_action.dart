import 'package:gamepads/gamepads.dart';

import '../../../options/translation_text.dart';
import '../gamepad_key_combo.dart';
import 'page_action.dart';

/// Moves to the previous tab. Bound to L by default.
class PreviousPageAction extends PageAction {
  PreviousPageAction();

  @override
  String get id => 'previous_page';

  @override
  TranslationText get title =>
      (t) => t.settings.gamepad.actionPreviousPage;

  @override
  final GamepadKeyCombo defaultCombo = GamepadKeyCombo.button(
    GamepadButton.leftBumper,
  );

  @override
  int get offset => -1;
}
