import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import 'data/folder_location.dart';
import 'data/logging_service.dart';
import 'data/master/legacy_database_import.dart';
import 'data/master/master_database.dart';
import 'data/master/repositories/citra_directory_repository.dart';
import 'data/master/repositories/first_launch_repository.dart';
import 'data/master/repositories/games_directory_repository.dart';
import 'data/master/repositories/legacy_user_directory_repository.dart';
import 'data/master/repositories/locations_repository.dart';
import 'data/master/repositories/master_settings_repository.dart';
import 'data/master/repositories/profile_repository.dart';
import 'data/profiles/profile_service.dart';
import 'data/repositories/installed_titles_repository.dart';
import 'data/repositories/loadable.dart';
import 'data/repositories/permission_repository.dart';
import 'data/settings/control_bindings_value_store.dart';
import 'data/settings/emulator_settings_repository.dart';
import 'data/settings/system_save_repository.dart';
import 'data/user/repositories/accessibility_settings_repository.dart';
import 'data/user/repositories/advanced_settings_repository.dart';
import 'data/user/repositories/artic_base_address_repository.dart';
import 'data/user/repositories/control_bindings_repository.dart';
import 'data/user/repositories/controller_settings_repository.dart';
import 'data/user/repositories/debug_settings_repository.dart';
import 'data/user/repositories/feature_flags_repository.dart';
import 'data/user/repositories/game_repository.dart';
import 'data/user/repositories/input_layout_repository.dart';
import 'data/user/repositories/language_code_repository.dart';
import 'data/user/repositories/legacy_settings_ui_repository.dart';
import 'data/user/repositories/media_settings_repository.dart';
import 'data/user/repositories/option_history_repository.dart';
import 'data/user/repositories/pinned_options_repository.dart';
import 'data/user/repositories/selected_tags_repository.dart';
import 'data/user/repositories/tag_repository.dart';
import 'data/user/repositories/theme_settings_repository.dart';
import 'data/user/repositories/user_game_info_repository.dart';
import 'data/user/repositories/virtual_access_points_repository.dart';
import 'data/user/user_database.dart';
import 'data/user/user_sessions.dart';
import 'data/user_files.dart';

/// The services of the app. The master services are created once, and the user services are
/// those of the user database of the active profile, which changes when the profile changes.
abstract final class AppServices {
  static final MasterDatabase masterDatabase = MasterDatabase();
  static final NativeBridge nativeBridge = NativeBridge();
  static final UserFiles userFiles = UserFiles.forPlatform(
    nativeBridge,
    root: () async {
      final profile = await profileRepository.activeProfile();
      return profile == null
          ? null
          : FolderLocation.toPath(profile.userDirectory);
    },
  );
  static final LoggingService loggingService = LoggingService(
    nativeBridge,
    userFiles,
  );
  static final PermissionRepository permissionRepository =
      PermissionRepository.forPlatform(nativeBridge);
  static final InstalledTitlesRepository installedTitlesRepository =
      InstalledTitlesRepository(nativeBridge);
  static final EmulatorSettingsRepository emulatorSettingsRepository =
      EmulatorSettingsRepository(nativeBridge);
  static final SystemSaveRepository systemSaveRepository = SystemSaveRepository(
    nativeBridge,
  );

  static final LocationsRepository locationsRepository = LocationsRepository(
    masterDatabase,
  );
  static final MasterSettingsRepository masterSettingsRepository =
      MasterSettingsRepository(masterDatabase);
  static final ProfileRepository profileRepository = ProfileRepository(
    masterDatabase,
  );
  static final FirstLaunchRepository firstLaunchRepository =
      FirstLaunchRepository(masterDatabase);
  static final CitraDirectoryRepository citraDirectoryRepository =
      CitraDirectoryRepository(masterDatabase, profileRepository);
  static final GamesDirectoryRepository gamesDirectoryRepository =
      GamesDirectoryRepository(masterDatabase, profileRepository);
  static final LegacyUserDirectoryRepository legacyUserDirectoryRepository =
      LegacyUserDirectoryRepository(masterDatabase);
  static final LegacyDatabaseImport legacyDatabaseImport = LegacyDatabaseImport(
    profileRepository,
    locationsRepository,
    masterSettingsRepository,
  );

  static final UserSessions userSessions = UserSessions(
    gamesDirectoryRepository,
    installedTitlesRepository,
  );

  static final ProfileService profileService = ProfileService(
    profileRepository,
    locationsRepository,
    masterSettingsRepository,
    userSessions,
    nativeBridge,
    citraDirectoryRepository,
    gamesDirectoryRepository,
    firstLaunchRepository,
    systemSaveRepository,
    loggingService,
    legacyUserDirectoryRepository,
  );

  static UserDatabase get database => userSessions.current.database;
  static GameRepository get gameRepository =>
      userSessions.current.gameRepository;
  static ControlBindingsRepository get controlBindingsRepository =>
      userSessions.current.controlBindingsRepository;
  static ControlBindingsValueStore get controlBindingsValueStore =>
      userSessions.current.controlBindingsValueStore;
  static ControllerSettingsRepository get controllerSettingsRepository =>
      userSessions.current.controllerSettingsRepository;
  static InputLayoutRepository get inputLayoutRepository =>
      userSessions.current.inputLayoutRepository;
  static ThemeSettingsRepository get themeSettingsRepository =>
      userSessions.current.themeSettingsRepository;
  static AccessibilitySettingsRepository get accessibilitySettingsRepository =>
      userSessions.current.accessibilitySettingsRepository;
  static AdvancedSettingsRepository get advancedSettingsRepository =>
      userSessions.current.advancedSettingsRepository;
  static MediaSettingsRepository get mediaSettingsRepository =>
      userSessions.current.mediaSettingsRepository;
  static DebugSettingsRepository get debugSettingsRepository =>
      userSessions.current.debugSettingsRepository;
  static VirtualAccessPointsRepository get virtualAccessPointsRepository =>
      userSessions.current.virtualAccessPointsRepository;
  static LanguageCodeRepository get languageCodeRepository =>
      userSessions.current.languageCodeRepository;
  static ArticBaseAddressRepository get articBaseAddressRepository =>
      userSessions.current.articBaseAddressRepository;
  static LegacySettingsUiRepository get legacySettingsUiRepository =>
      userSessions.current.legacySettingsUiRepository;
  static PinnedOptionsRepository get pinnedOptionsRepository =>
      userSessions.current.pinnedOptionsRepository;
  static OptionHistoryRepository get optionHistoryRepository =>
      userSessions.current.optionHistoryRepository;
  static TagRepository get tagRepository => userSessions.current.tagRepository;
  static UserGameInfoRepository get userGameInfoRepository =>
      userSessions.current.userGameInfoRepository;
  static SelectedTagsRepository get selectedTagsRepository =>
      userSessions.current.selectedTagsRepository;
  static FeatureFlagsRepository get featureFlagsRepository =>
      userSessions.current.featureFlagsRepository;

  /// Carries the data of an earlier version over when the master database does not exist yet.
  /// Runs before anything else reads the master database.
  static Future<void> prepareMasterDatabase() async {
    final isNew = !await (await MasterDatabase.file()).exists();
    if (isNew) await legacyDatabaseImport.run();
  }

  static List<Loadable> get loadables => [
    emulatorSettingsRepository,
    systemSaveRepository,
    ...userSessions.current.loadables,
  ];

  static Future<void> loadAll() async {
    for (final loadable in loadables) {
      await loadable.load();
    }
  }
}
