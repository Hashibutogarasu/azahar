import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../app_services.dart';
import 'media_session_metadata.dart';

class MediaSessionService {
  NativeBridge get _bridge => AppServices.nativeBridge;
  bool _active = false;
  StreamSubscription<void>? _stopSubscription;
  StreamSubscription<bool>? _playPauseSubscription;

  Future<void> activate(
    MediaSessionMetadata metadata, {
    required bool isPlaying,
    required VoidCallback onStop,
    required VoidCallback onPlay,
    required VoidCallback onPause,
  }) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    _active = true;
    await _stopSubscription?.cancel();
    _stopSubscription = _bridge.mediaNotificationStopRequests().listen(
      (_) => onStop(),
    );
    await _playPauseSubscription?.cancel();
    _playPauseSubscription = _bridge
        .mediaNotificationPlayPauseRequests()
        .listen((isPlaying) {
          if (isPlaying) {
            onPlay();
          } else {
            onPause();
          }
        });
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
    await _playPauseSubscription?.cancel();
    _playPauseSubscription = null;
    await _bridge.deactivateMediaNotification();
  }
}
