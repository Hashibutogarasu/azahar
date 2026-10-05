import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../gamepad/actions/gamepad_action.dart';
import '../gamepad/actions/gamepad_key_combo.dart';
import '../gamepad/actions/key_bindings_providers.dart';
import '../gamepad/key_binding.dart';
import 'option_value.dart';

/// The key combination bound to [action] in the controller profile in use, read from and written
/// to the controller settings, as the text `GamepadKeyCombo.serialize` writes.
class KeyBindingOptionValue extends OptionValue<String> {
  const KeyBindingOptionValue(this.action);

  final GamepadAction action;

  @override
  String read(WidgetRef ref) {
    final bindings = ref.watch(keyBindingsProvider(action.scope)).value;
    return (bindings?[action.id] ?? action.defaultCombo).serialize();
  }

  @override
  Future<void> write(BuildContext context, WidgetRef ref, String value) async {
    final profileId = ref.read(activeControllerProfileProvider);
    if (profileId == null) return;
    await AppServices.controllerSettingsRepository.write(
      KeyBinding(
        profileId: profileId,
        actionId: action.id,
        combo: GamepadKeyCombo.parse(value),
      ),
    );
  }
}
