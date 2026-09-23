import 'data/database.dart';
import 'data/game_repository.dart';
import 'data/settings/control_bindings_repository.dart';
import 'data/settings/emulator_settings_repository.dart';
import 'data/settings/input_layout_repository.dart';
import 'data/settings/system_save_repository.dart';
import 'data/settings/theme_settings_repository.dart';
import 'data/settings_repository.dart';
import 'native/native_bridge.dart';

abstract final class AppServices {
  static final AppDatabase database = AppDatabase();
  static final NativeBridge nativeBridge = NativeBridge();
  static final SettingsRepository settingsRepository = SettingsRepository(database);
  static final GameRepository gameRepository = GameRepository(database, nativeBridge);
  static final EmulatorSettingsRepository emulatorSettingsRepository =
      EmulatorSettingsRepository(nativeBridge);
  static final SystemSaveRepository systemSaveRepository = SystemSaveRepository(nativeBridge);
  static final ControlBindingsRepository controlBindingsRepository = ControlBindingsRepository(
    database,
  );
  static final InputLayoutRepository inputLayoutRepository = InputLayoutRepository(database);
  static final ThemeSettingsRepository themeSettingsRepository = ThemeSettingsRepository(
    database,
  );
}
