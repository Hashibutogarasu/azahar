import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import 'data/database.dart';
import 'data/logging_service.dart';
import 'data/repositories/accessibility_settings_repository.dart';
import 'data/repositories/advanced_settings_repository.dart';
import 'data/repositories/artic_base_address_repository.dart';
import 'data/repositories/citra_directory_repository.dart';
import 'data/repositories/control_bindings_repository.dart';
import 'data/repositories/debug_settings_repository.dart';
import 'data/repositories/first_launch_repository.dart';
import 'data/repositories/game_repository.dart';
import 'data/repositories/games_directory_repository.dart';
import 'data/repositories/input_layout_repository.dart';
import 'data/repositories/installed_titles_repository.dart';
import 'data/repositories/key_value_repository.dart';
import 'data/repositories/language_code_repository.dart';
import 'data/repositories/legacy_settings_ui_repository.dart';
import 'data/repositories/loadable.dart';
import 'data/repositories/media_settings_repository.dart';
import 'data/repositories/option_history_repository.dart';
import 'data/repositories/permission_repository.dart';
import 'data/repositories/pinned_options_repository.dart';
import 'data/repositories/theme_settings_repository.dart';
import 'data/repositories/virtual_access_points_repository.dart';
import 'data/settings/control_bindings_value_store.dart';
import 'data/settings/emulator_settings_repository.dart';
import 'data/settings/system_save_repository.dart';
import 'data/user_files.dart';

abstract final class AppServices {
  static final AppDatabase database = AppDatabase();
  static final NativeBridge nativeBridge = NativeBridge();
  static final UserFiles userFiles = UserFiles.forPlatform(nativeBridge);
  static final LoggingService loggingService = LoggingService(
    nativeBridge,
    userFiles,
  );
  static final PermissionRepository permissionRepository =
      PermissionRepository.forPlatform(nativeBridge);
  static final InstalledTitlesRepository installedTitlesRepository =
      InstalledTitlesRepository(nativeBridge);
  static final GameRepository gameRepository = GameRepository(
    database,
    gamesDirectoryRepository,
    installedTitlesRepository,
  );
  static final EmulatorSettingsRepository emulatorSettingsRepository =
      EmulatorSettingsRepository(nativeBridge);
  static final SystemSaveRepository systemSaveRepository = SystemSaveRepository(
    nativeBridge,
  );
  static final ControlBindingsRepository controlBindingsRepository =
      ControlBindingsRepository(database);
  static final ControlBindingsValueStore controlBindingsValueStore =
      ControlBindingsValueStore(controlBindingsRepository);
  static final InputLayoutRepository inputLayoutRepository =
      InputLayoutRepository(database);
  static final ThemeSettingsRepository themeSettingsRepository =
      ThemeSettingsRepository(database);
  static final AccessibilitySettingsRepository accessibilitySettingsRepository =
      AccessibilitySettingsRepository(database);
  static final AdvancedSettingsRepository advancedSettingsRepository =
      AdvancedSettingsRepository(database);
  static final MediaSettingsRepository mediaSettingsRepository =
      MediaSettingsRepository(database);
  static final DebugSettingsRepository debugSettingsRepository =
      DebugSettingsRepository(database);
  static final VirtualAccessPointsRepository virtualAccessPointsRepository =
      VirtualAccessPointsRepository(database);
  static final FirstLaunchRepository firstLaunchRepository =
      FirstLaunchRepository(database);
  static final CitraDirectoryRepository citraDirectoryRepository =
      CitraDirectoryRepository(database);
  static final GamesDirectoryRepository gamesDirectoryRepository =
      GamesDirectoryRepository(database);
  static final LanguageCodeRepository languageCodeRepository =
      LanguageCodeRepository(database);
  static final ArticBaseAddressRepository articBaseAddressRepository =
      ArticBaseAddressRepository(database);
  static final LegacySettingsUiRepository legacySettingsUiRepository =
      LegacySettingsUiRepository(database);
  static final PinnedOptionsRepository pinnedOptionsRepository =
      PinnedOptionsRepository(database);
  static final OptionHistoryRepository optionHistoryRepository =
      OptionHistoryRepository(database);

  static final List<KeyValueRepository> keyValueRepositories = [
    firstLaunchRepository,
    citraDirectoryRepository,
    gamesDirectoryRepository,
    languageCodeRepository,
    articBaseAddressRepository,
    legacySettingsUiRepository,
    virtualAccessPointsRepository,
  ];

  static Future<void> migrateKeyValueRepositories() async {
    for (final repository in keyValueRepositories) {
      await repository.migrate();
    }
  }

  static final List<Loadable> loadables = [
    emulatorSettingsRepository,
    systemSaveRepository,
    controlBindingsValueStore,
    languageCodeRepository,
    legacySettingsUiRepository,
  ];

  static Future<void> loadAll() async {
    for (final loadable in loadables) {
      await loadable.load();
    }
  }
}
