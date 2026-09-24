import 'package:flutter/foundation.dart';
import 'package:flutter_media_session/flutter_media_session.dart';

import 'media_session_metadata.dart';

class MediaSessionService {
  bool _active = false;

  Future<void> activate(
    MediaSessionMetadata metadata, {
    required bool isPlaying,
    required VoidCallback onStop,
  }) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    _active = true;
    FlutterMediaSession().setActionHandler(onStop: onStop);
    await FlutterMediaSession().activate();
    await FlutterMediaSessionPlatform.instance.updateMetadata(
      MediaMetadata(title: metadata.title, artworkUri: metadata.artworkUri),
    );
    await updatePlaybackState(isPlaying: isPlaying);
  }

  Future<void> updatePlaybackState({required bool isPlaying}) async {
    if (!_active) return;
    await FlutterMediaSessionPlatform.instance.updatePlaybackState(
      PlaybackState(status: isPlaying ? PlaybackStatus.playing : PlaybackStatus.paused),
    );
  }

  Future<void> deactivate() async {
    if (!_active) return;
    _active = false;
    FlutterMediaSession().clearActionHandler();
    await FlutterMediaSession().deactivate();
  }
}
