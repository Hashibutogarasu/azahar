import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../user/repositories/key_bindings_repository.dart';
import 'gamepad_action.dart';
import 'gamepad_key_combo.dart';

/// The repository that stores the key combinations of the actions of [scope].
KeyBindingsRepository keyBindingsRepositoryOf(GamepadActionScope scope) =>
    switch (scope) {
      GamepadActionScope.app => AppServices.appKeyBindingsRepository,
      GamepadActionScope.emulation =>
        AppServices.emulationKeyBindingsRepository,
    };

/// The key combination bound to each action of a scope, keyed by the action id.
final keyBindingsProvider =
    StreamProvider.family<Map<String, GamepadKeyCombo>, GamepadActionScope>(
      (ref, scope) => keyBindingsRepositoryOf(scope).watchAll(),
    );

/// The key combination bound to [action], or its default one until the stored bindings are read.
GamepadKeyCombo comboOf(Ref ref, GamepadAction action) {
  final bindings = ref.read(keyBindingsProvider(action.scope)).value;
  return bindings?[action.id] ?? action.defaultCombo;
}
