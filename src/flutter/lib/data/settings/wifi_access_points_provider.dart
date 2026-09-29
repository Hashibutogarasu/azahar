import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../models/access_point.dart';
import '../../native/native_bridge.dart';

final realAccessPointsProvider =
    AsyncNotifierProvider<RealAccessPointsNotifier, List<AccessPoint>>(
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
  const VirtualAccessPointsState({
    required this.enabled,
    required this.accessPoints,
  });

  final bool enabled;
  final List<AccessPoint> accessPoints;

  VirtualAccessPointsState copyWith({
    bool? enabled,
    List<AccessPoint>? accessPoints,
  }) {
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
    unawaited(_loadPersisted());
    return const VirtualAccessPointsState(enabled: false, accessPoints: []);
  }

  Future<void> _loadPersisted() async {
    final enabled = await AppServices.virtualAccessPointsRepository.isEnabled();
    final accessPoints = await AppServices.virtualAccessPointsRepository
        .readAll();
    state = VirtualAccessPointsState(
      enabled: enabled,
      accessPoints: accessPoints,
    );
    await _syncNative();
  }

  Future<void> setEnabled(bool enabled) async {
    state = state.copyWith(enabled: enabled);
    await _push();
  }

  Future<void> addAccessPoint(AccessPoint accessPoint) => addAll([accessPoint]);

  Future<void> addAll(List<AccessPoint> accessPoints) async {
    if (accessPoints.isEmpty) return;
    final result = [...state.accessPoints];
    for (final accessPoint in accessPoints) {
      final index = result.indexWhere(
        (it) => it.ssid == accessPoint.ssid && it.bssid == accessPoint.bssid,
      );
      if (index == -1) {
        result.add(accessPoint);
      } else {
        result[index] = accessPoint;
      }
    }
    state = state.copyWith(accessPoints: result);
    await _push();
  }

  Future<void> removeAccessPoint(AccessPoint accessPoint) async {
    state = state.copyWith(
      accessPoints: state.accessPoints
          .where((it) => it != accessPoint)
          .toList(),
    );
    await _push();
  }

  Future<void> updateAccessPoint(
    AccessPoint oldValue,
    AccessPoint newValue,
  ) async {
    state = state.copyWith(
      accessPoints: [
        for (final accessPoint in state.accessPoints)
          if (accessPoint == oldValue) newValue else accessPoint,
      ],
    );
    await _push();
  }

  Future<void> _push() async {
    await AppServices.virtualAccessPointsRepository.setEnabled(state.enabled);
    await AppServices.virtualAccessPointsRepository.writeAll(
      state.accessPoints,
    );
    await _syncNative();
  }

  Future<void> _syncNative() {
    return _bridge.setVirtualAccessPoints(
      state.enabled ? state.accessPoints : null,
    );
  }
}

final selectedRealAccessPointsProvider =
    NotifierProvider<SelectedAccessPointsNotifier, Set<AccessPoint>>(
      SelectedAccessPointsNotifier.new,
    );

class SelectedAccessPointsNotifier extends Notifier<Set<AccessPoint>> {
  @override
  Set<AccessPoint> build() => const {};

  void toggle(AccessPoint accessPoint) {
    final next = {...state};
    if (!next.remove(accessPoint)) {
      next.add(accessPoint);
    }
    state = next;
  }

  void clear() => state = const {};
}

final copiedAccessPointsProvider =
    NotifierProvider<CopiedAccessPointsNotifier, List<AccessPoint>>(
      CopiedAccessPointsNotifier.new,
    );

class CopiedAccessPointsNotifier extends Notifier<List<AccessPoint>> {
  @override
  List<AccessPoint> build() => const [];

  void copy(List<AccessPoint> accessPoints) => state = accessPoints;
}
