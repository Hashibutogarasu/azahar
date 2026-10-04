import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../app_services.dart';

final audioEngineProvider = NotifierProvider<AudioEngineNotifier, AudioEngine>(
  AudioEngineNotifier.new,
);

/// The [AudioEngine] that plays the audio of the next game, stored with the media settings.
class AudioEngineNotifier extends Notifier<AudioEngine> {
  @override
  AudioEngine build() {
    unawaited(_loadPersisted());
    return defaultAudioEngine();
  }

  Future<void> _loadPersisted() async {
    state = await read();
  }

  /// Reads the stored engine, falling back to the default when none is stored or the stored
  /// one is not available in this build.
  Future<AudioEngine> read() async {
    final settings = await AppServices.mediaSettingsRepository.read();
    final available = availableAudioEngines();
    return available
            .where((engine) => engine.name == settings.audioEngine)
            .firstOrNull ??
        defaultAudioEngine();
  }

  Future<void> select(AudioEngine engine) async {
    state = engine;
    final repository = AppServices.mediaSettingsRepository;
    final settings = await repository.read();
    await repository.write(
      settings.copyWith(audioEngine: Value(engine.name)),
    );
  }
}
