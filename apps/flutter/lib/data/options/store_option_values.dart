import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../settings/emulator_setting_key.dart';
import '../settings/settings_value_store.dart';
import 'option_value.dart';

/// Resolves the store an option reads and writes: its own, or the emulator settings repository.
SettingsValueStore _resolveStore(SettingsValueStore? store) =>
    store ?? AppServices.emulatorSettingsRepository;

Future<void> _persist(SettingsValueStore? store) async {
  if (_resolveStore(store) == AppServices.emulatorSettingsRepository) {
    await AppServices.emulatorSettingsRepository.save();
  }
}

/// A boolean stored as an integer emulator setting.
class StoreBoolValue extends OptionValue<bool> {
  const StoreBoolValue(this.setting, {this.store});

  final IntBoolKey setting;
  final SettingsValueStore? store;

  @override
  bool read(WidgetRef ref) => _resolveStore(store).readBool(setting);

  @override
  Future<void> write(BuildContext context, WidgetRef ref, bool value) async {
    await _resolveStore(store).writeBool(setting, value);
    await _persist(store);
  }
}

/// An integer emulator setting.
class StoreIntValue extends OptionValue<int> {
  const StoreIntValue(this.setting, {this.store});

  final IntKey setting;
  final SettingsValueStore? store;

  @override
  int read(WidgetRef ref) => _resolveStore(store).readInt(setting);

  @override
  Future<void> write(BuildContext context, WidgetRef ref, int value) async {
    await _resolveStore(store).writeInt(setting, value);
    await _persist(store);
  }
}

/// A floating-point emulator setting.
class StoreFloatValue extends OptionValue<double> {
  const StoreFloatValue(this.setting, {this.store});

  final FloatKey setting;
  final SettingsValueStore? store;

  @override
  double read(WidgetRef ref) => _resolveStore(store).readFloat(setting);

  @override
  Future<void> write(BuildContext context, WidgetRef ref, double value) async {
    await _resolveStore(store).writeFloat(setting, value);
    await _persist(store);
  }
}

/// A string emulator setting.
class StoreStringValue extends OptionValue<String> {
  const StoreStringValue(this.setting, {this.store});

  final StringKey setting;
  final SettingsValueStore? store;

  @override
  String read(WidgetRef ref) => _resolveStore(store).readString(setting);

  @override
  Future<void> write(BuildContext context, WidgetRef ref, String value) async {
    await _resolveStore(store).writeString(setting, value);
    await _persist(store);
  }
}
