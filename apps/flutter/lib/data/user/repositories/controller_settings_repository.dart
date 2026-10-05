import '../../gamepad/actions/gamepad_action.dart';
import '../../gamepad/actions/gamepad_action_registry.dart';
import '../../gamepad/actions/gamepad_key_combo.dart';
import '../../gamepad/controller_profile.dart';
import '../../gamepad/key_binding.dart';
import '../../gamepad/new_controller_profile.dart';
import '../../repositories/clearable.dart';
import '../../repositories/creatable.dart';
import '../../repositories/deletable.dart';
import '../../repositories/loadable.dart';
import '../../repositories/selectable.dart';
import '../../repositories/writable.dart';
import '../user_database.dart';
import 'active_controller_profile_repository.dart';
import 'app_key_bindings_repository.dart';
import 'controller_profile_repository.dart';
import 'emulation_key_bindings_repository.dart';
import 'key_bindings_repository.dart';

/// The controller settings: the controller profiles, the one in use, and the key bindings of the
/// actions that operate the app and the 3DS in each profile. The bindings of the app and of the
/// emulation stay in repositories of their own, which only this repository reaches.
///
/// [load] creates the built-in profile when there is none, makes sure the profile in use exists,
/// and registers the default combination of every action of the [registry] missing from a
/// profile. [create] adds a profile with the default bindings, [delete] removes a profile that is
/// not built in together with its bindings, [select] switches the profile in use, [write] binds a
/// combination to an action, and [clear] goes back to the built-in profile with its defaults.
class ControllerSettingsRepository
    implements
        Loadable,
        Clearable,
        Creatable<NewControllerProfile, ControllerProfile>,
        Deletable<String>,
        Selectable<String>,
        Writable<KeyBinding> {
  ControllerSettingsRepository(UserDatabase db, this.registry)
    : _profiles = ControllerProfileRepository(db),
      _activeProfile = ActiveControllerProfileRepository(db),
      _bindings = {
        GamepadActionScope.app: AppKeyBindingsRepository(db),
        GamepadActionScope.emulation: EmulationKeyBindingsRepository(db),
      },
      _db = db;

  final UserDatabase _db;
  final GamepadActionRegistry registry;
  final ControllerProfileRepository _profiles;
  final ActiveControllerProfileRepository _activeProfile;
  final Map<GamepadActionScope, KeyBindingsRepository> _bindings;
  String? _builtInProfileId;

  String get _builtInId =>
      _builtInProfileId ??
      (throw StateError('The controller settings are not loaded'));

  /// The cuid of the profile in use, or null before [load].
  String? get activeProfileId => _activeProfile.profileId ?? _builtInProfileId;

  @override
  Future<void> load() {
    return _db.transaction(() async {
      final builtIn =
          await _profiles.builtInProfile() ??
          await _profiles.create(
            const NewControllerProfile(name: '', isBuiltIn: true),
          );
      _builtInProfileId = builtIn.cuid;
      await _activeProfile.load();
      final profiles = await _profiles.profiles();
      if (!profiles.any(
        (profile) => profile.cuid == _activeProfile.profileId,
      )) {
        await _activeProfile.select(builtIn.cuid);
      }
      for (final profile in profiles) {
        await _registerDefaults(profile.cuid);
      }
    });
  }

  Future<void> _registerDefaults(String profileId) async {
    for (final MapEntry(key: scope, value: bindings) in _bindings.entries) {
      for (final action in registry.actionsOf(scope)) {
        await bindings.create(
          KeyBinding(
            profileId: profileId,
            actionId: action.id,
            combo: action.defaultCombo,
          ),
        );
      }
    }
  }

  @override
  Future<ControllerProfile> create(NewControllerProfile value) {
    return _db.transaction(() async {
      final profile = await _profiles.create(value);
      await _registerDefaults(profile.cuid);
      return profile;
    });
  }

  @override
  Future<void> delete(String key) {
    if (key == _builtInId) return Future.value();
    return _db.transaction(() async {
      for (final bindings in _bindings.values) {
        await bindings.delete(key);
      }
      await _profiles.delete(key);
      if (_activeProfile.profileId == key) {
        await _activeProfile.select(_builtInId);
      }
    });
  }

  @override
  Future<void> select(String key) => _activeProfile.select(key);

  @override
  Future<void> write(KeyBinding value) async {
    final action = registry.byId(value.actionId);
    if (action == null) return;
    await _bindings[action.scope]!.write(value);
  }

  @override
  Future<void> clear() {
    return _db.transaction(() async {
      for (final bindings in _bindings.values) {
        await bindings.clear();
      }
      await _profiles.clear();
      await _activeProfile.select(_builtInId);
      await _registerDefaults(_builtInId);
    });
  }

  /// Every profile, oldest first, and again whenever they change.
  Stream<List<ControllerProfile>> watchProfiles() => _profiles.watchProfiles();

  /// The combination bound to each action of [scope] in the profile [profileId], keyed by the
  /// action id, and again whenever it changes.
  Stream<Map<String, GamepadKeyCombo>> watchBindings(
    GamepadActionScope scope,
    String profileId,
  ) {
    return _bindings[scope]!.watchAll(profileId);
  }
}
