import 'package:gamepads/gamepads.dart';

import '../../../options/translation_text.dart';
import '../gamepad_key_combo.dart';
import 'page_action.dart';

/// Moves to the next tab. Bound to R by default.
class NextPageAction extends PageAction {
  NextPageAction();

  @override
  String get id => 'next_page';

  @override
  TranslationText get title =>
      (t) => t.settings.gamepad.actionNextPage;

  @override
  final GamepadKeyCombo defaultCombo = GamepadKeyCombo.button(
    GamepadButton.rightBumper,
  );

  @override
  int get offset => 1;
}
