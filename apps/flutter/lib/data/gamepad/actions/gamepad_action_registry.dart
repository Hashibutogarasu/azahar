import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app_actions.dart';
import 'console/console_actions.dart';
import 'emulation/toggle_emulation_focus_action.dart';
import 'gamepad_action.dart';

/// Every [GamepadAction] the app knows, in the order they were registered.
class GamepadActionRegistry {
  GamepadActionRegistry();

  /// The registry with every action of the app, shared by the database and the providers.
  static final GamepadActionRegistry standard = GamepadActionRegistry()
    ..registerAll(appActions)
    ..register(ToggleEmulationFocusAction())
    ..registerAll(consoleActions);

  final Map<String, GamepadAction> _actions = {};

  /// Adds [action]. Its id must not be registered yet.
  void register(GamepadAction action) {
    assert(
      !_actions.containsKey(action.id),
      'The gamepad action ${action.id} is already registered.',
    );
    _actions[action.id] = action;
  }

  void registerAll(Iterable<GamepadAction> actions) {
    for (final action in actions) {
      register(action);
    }
  }

  Iterable<GamepadAction> get actions => _actions.values;

  /// The registered actions used in [scope], in the order they were registered.
  Iterable<GamepadAction> actionsOf(GamepadActionScope scope) =>
      _actions.values.where((action) => action.scope == scope);

  /// The action registered under [id], if any.
  GamepadAction? byId(String id) => _actions[id];
}

/// The registry with every action of the app.
final gamepadActionRegistryProvider = Provider<GamepadActionRegistry>(
  (ref) => GamepadActionRegistry.standard,
);
