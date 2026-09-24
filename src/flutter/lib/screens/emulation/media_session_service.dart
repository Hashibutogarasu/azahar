import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../app_services.dart';
import '../../native/native_bridge.dart';
import 'media_session_metadata.dart';

class MediaSessionService {
  NativeBridge get _bridge => AppServices.nativeBridge;
  bool _active = false;
  StreamSubscription<void>? _stopSubscription;

  Future<void> activate(
    MediaSessionMetadata metadata, {
    required bool isPlaying,
    required VoidCallback onStop,
  }) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    _active = true;
    await _stopSubscription?.cancel();
    _stopSubscription = _bridge.mediaNotificationStopRequests().listen((_) => onStop());
    await _bridge.activateMediaNotification(
      title: metadata.title,
      artworkPath: metadata.artworkPath,
      isPlaying: isPlaying,
    );
  }

  Future<void> updatePlaybackState({required bool isPlaying}) async {
    if (!_active) return;
    await _bridge.updateMediaNotificationPlaybackState(isPlaying: isPlaying);
  }

  Future<void> deactivate() async {
    if (!_active) return;
    _active = false;
    await _stopSubscription?.cancel();
    _stopSubscription = null;
    await _bridge.deactivateMediaNotification();
  }
}
