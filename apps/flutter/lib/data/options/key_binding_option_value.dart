import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../gamepad/actions/gamepad_action.dart';
import '../gamepad/actions/gamepad_key_combo.dart';
import '../gamepad/actions/key_bindings_providers.dart';
import 'option_value.dart';

/// The key combination bound to [action], read from and written to the key binding table of its
/// scope, as the text `GamepadKeyCombo.serialize` writes.
class KeyBindingOptionValue extends OptionValue<String> {
  const KeyBindingOptionValue(this.action);

  final GamepadAction action;

  @override
  String read(WidgetRef ref) {
    final bindings = ref.watch(keyBindingsProvider(action.scope)).value;
    return (bindings?[action.id] ?? action.defaultCombo).serialize();
  }

  @override
  Future<void> write(BuildContext context, WidgetRef ref, String value) {
    return keyBindingsRepositoryOf(
      action.scope,
    ).write(action.id, GamepadKeyCombo.parse(value));
  }
}
