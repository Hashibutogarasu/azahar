import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../native/native_bridge.dart';
import 'emulator_setting_key.dart';
import 'sections/audio_settings.dart';
import 'settings_value_store.dart';

final mediaVolumeProvider = NotifierProvider<MediaVolumeNotifier, double>(
  MediaVolumeNotifier.new,
);

class MediaVolumeNotifier extends Notifier<double> {
  NativeBridge get _bridge => AppServices.nativeBridge;

  StreamSubscription<double>? _nativeSubscription;

  double get volume => state;

  @override
  double build() {
    ref.onDispose(stopNativeSync);
    return AppServices.emulatorSettingsRepository.readFloat(AudioSettingKeys.volume);
  }

  Future<void> setVolume(double percentage) async {
    state = percentage;
    await AppServices.emulatorSettingsRepository.writeFloat(AudioSettingKeys.volume, percentage);
    await AppServices.emulatorSettingsRepository.save();
    if (_nativeSubscription != null) {
      await _bridge.setSystemMediaVolume(percentage / 100);
    }
  }

  Future<void> startNativeSync() async {
    if (_nativeSubscription != null) return;
    final nativeVolume = await _bridge.getSystemMediaVolume();
    await setVolume(nativeVolume * 100);
    _nativeSubscription = _bridge.systemMediaVolumeChanges().listen((fraction) {
      unawaited(setVolume(fraction * 100));
    });
  }

  Future<void> stopNativeSync() async {
    await _nativeSubscription?.cancel();
    _nativeSubscription = null;
  }
}

class MediaVolumeValueStore implements SettingsValueStore {
  MediaVolumeValueStore(this._notifier);

  final MediaVolumeNotifier _notifier;

  @override
  double readFloat(FloatKey setting) => _notifier.volume;

  @override
  Future<void> writeFloat(FloatKey setting, double value) => _notifier.setVolume(value);

  @override
  int readInt(IntKey setting) => setting.defaultValue;

  @override
  Future<void> writeInt(IntKey setting, int value) => Future.value();

  @override
  bool readBool(IntBoolKey setting) => setting.defaultValue != 0;

  @override
  Future<void> writeBool(IntBoolKey setting, bool value) => Future.value();

  @override
  String readString(StringKey setting) => setting.defaultValue;

  @override
  Future<void> writeString(StringKey setting, String value) => Future.value();
}
