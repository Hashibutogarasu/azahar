import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../models/access_point.dart';
import '../../native/native_bridge.dart';

final realAccessPointsProvider = AsyncNotifierProvider<RealAccessPointsNotifier, List<AccessPoint>>(
  RealAccessPointsNotifier.new,
);

class RealAccessPointsNotifier extends AsyncNotifier<List<AccessPoint>> {
  NativeBridge get _bridge => AppServices.nativeBridge;

  @override
  Future<List<AccessPoint>> build() => _bridge.scanRealWifiAccessPoints();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _bridge.scanRealWifiAccessPoints());
  }
}

class VirtualAccessPointsState {
  const VirtualAccessPointsState({required this.enabled, required this.accessPoints});

  final bool enabled;
  final List<AccessPoint> accessPoints;

  VirtualAccessPointsState copyWith({bool? enabled, List<AccessPoint>? accessPoints}) {
    return VirtualAccessPointsState(
      enabled: enabled ?? this.enabled,
      accessPoints: accessPoints ?? this.accessPoints,
    );
  }
}

final virtualAccessPointsProvider =
    NotifierProvider<VirtualAccessPointsNotifier, VirtualAccessPointsState>(
  VirtualAccessPointsNotifier.new,
);

class VirtualAccessPointsNotifier extends Notifier<VirtualAccessPointsState> {
  NativeBridge get _bridge => AppServices.nativeBridge;

  @override
  VirtualAccessPointsState build() {
    ref.onDispose(() => unawaited(_bridge.setVirtualAccessPoints(null)));
    return const VirtualAccessPointsState(enabled: false, accessPoints: []);
  }

  Future<void> setEnabled(bool enabled) async {
    state = state.copyWith(enabled: enabled);
    await _push();
  }

  Future<void> addAccessPoint(AccessPoint accessPoint) async {
    state = state.copyWith(accessPoints: [...state.accessPoints, accessPoint]);
    await _push();
  }

  Future<void> removeAccessPoint(AccessPoint accessPoint) async {
    state = state.copyWith(
      accessPoints: state.accessPoints.where((it) => it != accessPoint).toList(),
    );
    await _push();
  }

  Future<void> _push() {
    return _bridge.setVirtualAccessPoints(state.enabled ? state.accessPoints : null);
  }
}
