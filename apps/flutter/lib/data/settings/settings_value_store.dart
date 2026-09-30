import 'emulator_setting_key.dart';

abstract class SettingsValueStore {
  int readInt(IntKey setting);

  Future<void> writeInt(IntKey setting, int value);

  bool readBool(IntBoolKey setting);

  Future<void> writeBool(IntBoolKey setting, bool value);

  double readFloat(FloatKey setting);

  Future<void> writeFloat(FloatKey setting, double value);

  String readString(StringKey setting);

  Future<void> writeString(StringKey setting, String value);
}
