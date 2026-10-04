use flutter_rust_bridge::frb;

/// Engine that plays the audio of a session.
///
/// Every variant exists on every platform so that the generated Dart type is the same
/// everywhere. Which engines a build can actually use is reported by
/// [`available_audio_engines`].
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum AudioEngine {
    /// The OpenAL sink of the core.
    OpenAl,
    /// Oboe, driven by this crate. Only available on Android.
    Oboe,
}

impl AudioEngine {
    /// Returns the engine that is used when this one is requested, falling back to
    /// [`AudioEngine::OpenAl`] when the engine is not available in this build.
    #[frb(ignore)]
    pub fn effective(self) -> AudioEngine {
        if available_audio_engines().contains(&self) {
            self
        } else {
            default_audio_engine()
        }
    }
}

/// Returns the engines this build can play audio with, in the order the settings list them.
#[frb(sync)]
pub fn available_audio_engines() -> Vec<AudioEngine> {
    vec![
        #[cfg(target_os = "android")]
        AudioEngine::Oboe,
        AudioEngine::OpenAl,
    ]
}

/// Returns the engine used when none has been chosen yet.
#[frb(sync)]
pub fn default_audio_engine() -> AudioEngine {
    available_audio_engines()
        .first()
        .copied()
        .unwrap_or(AudioEngine::OpenAl)
}
