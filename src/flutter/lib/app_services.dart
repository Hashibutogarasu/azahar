import 'data/database.dart';
import 'data/game_repository.dart';
import 'data/settings/emulator_settings_repository.dart';
import 'data/settings_repository.dart';
import 'native/native_bridge.dart';

abstract final class AppServices {
  static final AppDatabase database = AppDatabase();
  static final NativeBridge nativeBridge = NativeBridge();
  static final SettingsRepository settingsRepository = SettingsRepository(database);
  static final GameRepository gameRepository = GameRepository(database, nativeBridge);
  static final EmulatorSettingsRepository emulatorSettingsRepository =
      EmulatorSettingsRepository(nativeBridge);
}
