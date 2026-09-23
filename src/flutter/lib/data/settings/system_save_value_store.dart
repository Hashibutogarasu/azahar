import 'emulator_setting_key.dart';
import 'settings_value_store.dart';
import 'system_save_repository.dart';

/// Adapts [SystemSaveRepository] to [SettingsValueStore] so `SettingsList` can read and write
/// 3DS system save fields (Username, Birthday, Play Coins, Country, …) through the same
/// [IntKey]/[StringKey] model used for `config.ini` settings, using each key's `key` string as
/// the field name. The [SystemSaveRepository] itself stays isolated from `config.ini` and from
/// the Drift-backed app settings store.
class SystemSaveValueStore implements SettingsValueStore {
  SystemSaveValueStore(this._repository);

  final SystemSaveRepository _repository;

  @override
  int readInt(IntKey setting) {
    return switch (setting.key) {
      'birthdayMonth' => _repository.birthdayMonth,
      'birthdayDay' => _repository.birthdayDay,
      'systemLanguage' => _repository.systemLanguage,
      'soundOutputMode' => _repository.soundOutputMode,
      'countryCode' => _repository.countryCode,
      'playCoins' => _repository.playCoins,
      _ => setting.defaultValue,
    };
  }

  @override
  Future<void> writeInt(IntKey setting, int value) {
    return switch (setting.key) {
      'birthdayMonth' => _repository.setBirthday(month: value),
      'birthdayDay' => _repository.setBirthday(day: value),
      'systemLanguage' => _repository.setSystemLanguage(value),
      'soundOutputMode' => _repository.setSoundOutputMode(value),
      'countryCode' => _repository.setCountryCode(value),
      'playCoins' => _repository.setPlayCoins(value),
      _ => Future.value(),
    };
  }

  @override
  bool readBool(IntBoolKey setting) => readInt(setting) != 0;

  @override
  Future<void> writeBool(IntBoolKey setting, bool value) {
    return writeInt(setting, value ? 1 : 0);
  }

  @override
  double readFloat(FloatKey setting) => setting.defaultValue;

  @override
  Future<void> writeFloat(FloatKey setting, double value) => Future.value();

  @override
  String readString(StringKey setting) {
    return switch (setting.key) {
      'username' => _repository.username,
      'countryCode' => _repository.countryCode.toString(),
      'consoleId' => _repository.consoleId,
      'mac' => _repository.mac,
      _ => setting.defaultValue,
    };
  }

  @override
  Future<void> writeString(StringKey setting, String value) {
    return switch (setting.key) {
      'username' => _repository.setUsername(value),
      'countryCode' => _repository.setCountryCode(int.parse(value)),
      _ => Future.value(),
    };
  }
}
