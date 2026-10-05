import '../../gamepad/actions/gamepad_action.dart';
import '../../gamepad/actions/gamepad_action_registry.dart';
import '../../gamepad/actions/gamepad_key_combo.dart';
import '../../repositories/clearable.dart';
import '../../repositories/loadable.dart';
import '../user_database.dart';

/// Stores the key combination bound to each [GamepadAction] of one [scope], in a table of its
/// own.
abstract class KeyBindingsRepository implements Loadable, Clearable {
  KeyBindingsRepository(this.db, this.registry);

  final UserDatabase db;
  final GamepadActionRegistry registry;

  GamepadActionScope get scope;

  Iterable<GamepadAction> get _actions => registry.actionsOf(scope);

  /// Inserts [actionId] bound to [combo] unless it is already stored.
  Future<void> insertIfAbsent(String actionId, String combo);

  /// Stores [combo] for [actionId], replacing what was stored.
  Future<void> upsert(String actionId, String combo);

  /// Removes every row whose action id is not one of [actionIds].
  Future<void> deleteExcept(Iterable<String> actionIds);

  /// Removes every row.
  Future<void> deleteAll();

  /// Every stored row, as action id and serialized combination, and again whenever it changes.
  Stream<Map<String, String>> watchRows();

  @override
  Future<void> load() => registerDefaults();

  /// Adds the default combination of every registered action missing from the table, and removes
  /// the rows of actions that are no longer registered.
  Future<void> registerDefaults() {
    return db.transaction(() async {
      for (final action in _actions) {
        await insertIfAbsent(action.id, action.defaultCombo.serialize());
      }
      await deleteExcept(_actions.map((action) => action.id));
    });
  }

  /// The combination bound to each action, keyed by the action id, and again whenever it changes.
  Stream<Map<String, GamepadKeyCombo>> watchAll() {
    return watchRows().map(
      (rows) => {
        for (final MapEntry(:key, :value) in rows.entries)
          key: GamepadKeyCombo.parse(value),
      },
    );
  }

  /// Binds [combo] to the action registered under [actionId].
  Future<void> write(String actionId, GamepadKeyCombo combo) =>
      upsert(actionId, combo.serialize());

  /// Binds [action] to its default combination again.
  Future<void> resetToDefault(GamepadAction action) =>
      write(action.id, action.defaultCombo);

  /// Binds every action to its default combination again.
  @override
  Future<void> clear() async {
    await deleteAll();
    await registerDefaults();
  }
}
