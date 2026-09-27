import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../native/native_bridge.dart';
import '../database.dart';

final masterVolumeProvider = NotifierProvider<MasterVolumeNotifier, double>(
  MasterVolumeNotifier.new,
);

class MasterVolumeNotifier extends Notifier<double> {
  NativeBridge get _bridge => AppServices.nativeBridge;

  StreamSubscription<double>? _nativeSubscription;

  @override
  double build() {
    ref.onDispose(stopNativeSync);
    unawaited(_loadPersisted());
    return 100;
  }

  Future<void> _loadPersisted() async {
    final settings = await AppServices.mediaSettingsRepository.read();
    state = settings.masterVolume;
  }

  /// Applies [percentage] (0-100) to the system media stream immediately, without persisting it.
  Future<void> setVolume(double percentage) async {
    state = percentage;
    await _bridge.setSystemMediaVolume(percentage / 100);
  }

  /// Persists the current volume. Callers should invoke this once a drag gesture ends, not on
  /// every intermediate value, to avoid frequent database writes.
  Future<void> persistVolume() {
    return AppServices.mediaSettingsRepository.write(
      MediaSetting(id: 0, masterVolume: state),
    );
  }

  Future<void> startNativeSync() async {
    if (_nativeSubscription != null) return;
    final nativeVolume = await _bridge.getSystemMediaVolume();
    state = nativeVolume * 100;
    await persistVolume();
    _nativeSubscription = _bridge.systemMediaVolumeChanges().listen((fraction) {
      state = fraction * 100;
      unawaited(persistVolume());
    });
  }

  Future<void> stopNativeSync() async {
    await _nativeSubscription?.cancel();
    _nativeSubscription = null;
  }
}
