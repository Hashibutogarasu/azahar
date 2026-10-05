import '../../gamepad/actions/gamepad_action.dart';
import '../../gamepad/actions/gamepad_key_combo.dart';
import '../../gamepad/key_binding.dart';
import '../../repositories/clearable.dart';
import '../../repositories/creatable.dart';
import '../../repositories/deletable.dart';
import '../../repositories/writable.dart';
import '../user_database.dart';

/// Stores the key combinations of the [GamepadAction]s of one [scope], per controller profile, in a
/// table of its own. It is only used through the `ControllerSettingsRepository`.
///
/// [create] adds a binding unless the action already has one in its profile, [write] replaces it,
/// [delete] removes every binding of a profile and [clear] removes every binding.
abstract class KeyBindingsRepository
    implements
        Creatable<KeyBinding, void>,
        Writable<KeyBinding>,
        Deletable<String>,
        Clearable {
  KeyBindingsRepository(this.db);

  final UserDatabase db;

  GamepadActionScope get scope;

  /// Every binding of the profile [profileId], as action id and serialized combination, and
  /// again whenever it changes.
  Stream<Map<String, String>> watchRows(String profileId);

  /// The combination bound to each action of the profile [profileId], keyed by the action id, and
  /// again whenever it changes.
  Stream<Map<String, GamepadKeyCombo>> watchAll(String profileId) {
    return watchRows(profileId).map(
      (rows) => {
        for (final MapEntry(:key, :value) in rows.entries)
          key: GamepadKeyCombo.parse(value),
      },
    );
  }
}
