import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../settings/settings_load_provider.dart';
import '../controller_profile.dart';
import '../new_controller_profile.dart';
import 'gamepad_action.dart';
import 'gamepad_key_combo.dart';

/// Every controller profile, oldest first.
final controllerProfilesProvider = StreamProvider<List<ControllerProfile>>(
  (ref) => AppServices.controllerSettingsRepository.watchProfiles(),
);

/// The cuid of the controller profile in use, or null until the settings are loaded.
final activeControllerProfileProvider =
    NotifierProvider<ActiveControllerProfileNotifier, String?>(
      ActiveControllerProfileNotifier.new,
    );

/// Keeps [activeControllerProfileProvider] in step with the controller settings while profiles
/// are created, switched and deleted through it.
class ActiveControllerProfileNotifier extends Notifier<String?> {
  @override
  String? build() {
    if (!ref.watch(settingsLoadProvider)) return null;
    return AppServices.controllerSettingsRepository.activeProfileId;
  }

  /// Adds a profile named [name] with the default bindings.
  Future<ControllerProfile> create(String name) {
    return AppServices.controllerSettingsRepository.create(
      NewControllerProfile(name: name),
    );
  }

  /// Switches to the profile [cuid].
  Future<void> select(String cuid) async {
    await AppServices.controllerSettingsRepository.select(cuid);
    state = AppServices.controllerSettingsRepository.activeProfileId;
  }

  /// Removes the profile [cuid] and its bindings, switching to the built-in profile if it was in
  /// use.
  Future<void> delete(String cuid) async {
    await AppServices.controllerSettingsRepository.delete(cuid);
    state = AppServices.controllerSettingsRepository.activeProfileId;
  }
}

/// The key combination bound to each action of a scope in the controller profile in use, keyed by
/// the action id.
final keyBindingsProvider =
    StreamProvider.family<Map<String, GamepadKeyCombo>, GamepadActionScope>((
      ref,
      scope,
    ) {
      final profileId = ref.watch(activeControllerProfileProvider);
      if (profileId == null) return const Stream.empty();
      return AppServices.controllerSettingsRepository.watchBindings(
        scope,
        profileId,
      );
    });

/// The key combination bound to [action], or its default one until the stored bindings are read.
GamepadKeyCombo comboOf(Ref ref, GamepadAction action) {
  final bindings = ref.read(keyBindingsProvider(action.scope)).value;
  return bindings?[action.id] ?? action.defaultCombo;
}
