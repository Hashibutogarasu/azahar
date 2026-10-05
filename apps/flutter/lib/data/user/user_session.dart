import 'dart:io';

import '../gamepad/actions/gamepad_action_registry.dart';
import '../master/repositories/games_directory_repository.dart';
import '../repositories/installed_titles_repository.dart';
import '../repositories/loadable.dart';
import '../settings/control_bindings_value_store.dart';
import 'repositories/accessibility_settings_repository.dart';
import 'repositories/advanced_settings_repository.dart';
import 'repositories/artic_base_address_repository.dart';
import 'repositories/control_bindings_repository.dart';
import 'repositories/controller_settings_repository.dart';
import 'repositories/debug_settings_repository.dart';
import 'repositories/feature_flags_repository.dart';
import 'repositories/game_repository.dart';
import 'repositories/input_layout_repository.dart';
import 'repositories/key_value_repository.dart';
import 'repositories/language_code_repository.dart';
import 'repositories/legacy_settings_ui_repository.dart';
import 'repositories/media_settings_repository.dart';
import 'repositories/option_history_repository.dart';
import 'repositories/pinned_options_repository.dart';
import 'repositories/selected_tags_repository.dart';
import 'repositories/tag_repository.dart';
import 'repositories/theme_settings_repository.dart';
import 'repositories/user_game_info_repository.dart';
import 'repositories/virtual_access_points_repository.dart';
import 'user_database.dart';

/// The user database of one profile together with the repositories that read it.
class UserSession {
  UserSession(
    this.file,
    GamesDirectoryRepository gamesDirectoryRepository,
    InstalledTitlesRepository installedTitlesRepository,
  ) : database = UserDatabase(file) {
    gameRepository = GameRepository(
      database,
      gamesDirectoryRepository,
      installedTitlesRepository,
    );
    controlBindingsRepository = ControlBindingsRepository(database);
    controlBindingsValueStore = ControlBindingsValueStore(
      controlBindingsRepository,
    );
    controllerSettingsRepository = ControllerSettingsRepository(
      database,
      GamepadActionRegistry.standard,
    );
    inputLayoutRepository = InputLayoutRepository(database);
    themeSettingsRepository = ThemeSettingsRepository(database);
    accessibilitySettingsRepository = AccessibilitySettingsRepository(database);
    advancedSettingsRepository = AdvancedSettingsRepository(database);
    mediaSettingsRepository = MediaSettingsRepository(database);
    debugSettingsRepository = DebugSettingsRepository(database);
    virtualAccessPointsRepository = VirtualAccessPointsRepository(database);
    languageCodeRepository = LanguageCodeRepository(database);
    articBaseAddressRepository = ArticBaseAddressRepository(database);
    legacySettingsUiRepository = LegacySettingsUiRepository(database);
    pinnedOptionsRepository = PinnedOptionsRepository(database);
    optionHistoryRepository = OptionHistoryRepository(database);
    tagRepository = TagRepository(database);
    userGameInfoRepository = UserGameInfoRepository(database);
    selectedTagsRepository = SelectedTagsRepository(database);
    featureFlagsRepository = FeatureFlagsRepository(database);
  }

  final File file;
  final UserDatabase database;
  late final GameRepository gameRepository;
  late final ControlBindingsRepository controlBindingsRepository;
  late final ControlBindingsValueStore controlBindingsValueStore;
  late final ControllerSettingsRepository controllerSettingsRepository;
  late final InputLayoutRepository inputLayoutRepository;
  late final ThemeSettingsRepository themeSettingsRepository;
  late final AccessibilitySettingsRepository accessibilitySettingsRepository;
  late final AdvancedSettingsRepository advancedSettingsRepository;
  late final MediaSettingsRepository mediaSettingsRepository;
  late final DebugSettingsRepository debugSettingsRepository;
  late final VirtualAccessPointsRepository virtualAccessPointsRepository;
  late final LanguageCodeRepository languageCodeRepository;
  late final ArticBaseAddressRepository articBaseAddressRepository;
  late final LegacySettingsUiRepository legacySettingsUiRepository;
  late final PinnedOptionsRepository pinnedOptionsRepository;
  late final OptionHistoryRepository optionHistoryRepository;
  late final TagRepository tagRepository;
  late final UserGameInfoRepository userGameInfoRepository;
  late final SelectedTagsRepository selectedTagsRepository;
  late final FeatureFlagsRepository featureFlagsRepository;

  List<KeyValueRepository> get _keyValueRepositories => [
    languageCodeRepository,
    articBaseAddressRepository,
    legacySettingsUiRepository,
    virtualAccessPointsRepository,
  ];

  List<Loadable> get loadables => [
    controlBindingsValueStore,
    controllerSettingsRepository,
    languageCodeRepository,
    legacySettingsUiRepository,
    featureFlagsRepository,
  ];

  /// Renames the keys an earlier version stored under other names.
  Future<void> migrateKeys() async {
    for (final repository in _keyValueRepositories) {
      await repository.migrate();
    }
  }
}
