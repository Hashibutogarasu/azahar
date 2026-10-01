//! The black-box game session.

use std::sync::Arc;

use crate::audio::AudioOutput;
use crate::error::{AzaharError, Result};
use crate::ffi::{CallbackContext, CoreListener, SessionHandle};
use crate::memory::Memory3ds;

/// Phase of the shader cache preparation reported by the core.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ShaderStage {
    Prepare,
    Decompile,
    Build,
    Complete,
}

/// Lifecycle state of a session.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SessionState {
    Idle,
    Running,
    Paused,
}

/// Notification delivered from the session to the application.
#[derive(Debug, Clone)]
pub enum SessionEvent {
    ShaderProgress {
        stage: ShaderStage,
        progress: u64,
        max: u64,
    },
    Texture {
        texture_id: i64,
        secondary: bool,
    },
    StateChanged {
        state: SessionState,
    },
    Error {
        message: String,
    },
}

/// Size of the screen textures of a session.
#[derive(Debug, Clone, Copy)]
pub struct SessionOptions {
    pub primary_width: i32,
    pub primary_height: i32,
    pub secondary_width: i32,
    pub secondary_height: i32,
    pub dual_screen: bool,
}

/// Callback receiving the events of one session.
pub type EventSink = Arc<dyn Fn(SessionEvent) + Send + Sync>;

struct Listener {
    events: EventSink,
    audio: Option<Arc<AudioOutput>>,
}

impl CoreListener for Listener {
    fn on_event(&self, event: SessionEvent) {
        (self.events)(event);
    }

    fn on_audio(&self, frames: &[i16]) {
        if let Some(audio) = &self.audio {
            audio.push(frames);
        }
    }
}

/// One running game together with everything it owns.
///
/// The fields are declared in release order. Dropping the session first
/// destroys the core handle, which joins the core threads and frees the 3DS
/// memory, so no callback can run afterwards. Only then are the callback
/// context and the audio output released.
pub struct GameSession {
    handle: SessionHandle,
    _context: Box<CallbackContext>,
    audio: Option<Arc<AudioOutput>>,
    events: EventSink,
    state: SessionState,
}

impl GameSession {
    /// Creates the session and starts emulation and shader preparation.
    pub fn start(game_path: &str, options: &SessionOptions, events: EventSink) -> Result<Self> {
        let audio = match AudioOutput::new() {
            Ok(audio) => Some(Arc::new(audio)),
            Err(error) => {
                events(SessionEvent::Error {
                    message: error.to_string(),
                });
                None
            }
        };
        let context = CallbackContext::new(Arc::new(Listener {
            events: Arc::clone(&events),
            audio: audio.clone(),
        }));
        let handle = SessionHandle::create(game_path, options, &context)?;
        handle.start()?;

        let session = Self {
            handle,
            _context: context,
            audio,
            events,
            state: SessionState::Running,
        };
        session.notify_state();
        Ok(session)
    }

    pub fn state(&self) -> SessionState {
        self.state
    }

    pub fn pause(&mut self) -> Result<()> {
        if self.state != SessionState::Running {
            return Err(AzaharError::InvalidState);
        }
        self.handle.pause()?;
        if let Some(audio) = &self.audio {
            audio.pause();
        }
        self.state = SessionState::Paused;
        self.notify_state();
        Ok(())
    }

    pub fn resume(&mut self) -> Result<()> {
        if self.state != SessionState::Paused {
            return Err(AzaharError::InvalidState);
        }
        self.handle.resume()?;
        if let Some(audio) = &self.audio {
            audio.resume();
        }
        self.state = SessionState::Running;
        self.notify_state();
        Ok(())
    }

    pub fn set_volume(&self, volume: f32) {
        if let Some(audio) = &self.audio {
            audio.set_volume(volume);
        }
    }

    /// Read-only access to the 3DS memory of this session.
    pub fn memory(&self) -> Memory3ds<'_> {
        Memory3ds::new(&self.handle)
    }

    /// Stops the game and blocks until every resource has been released.
    pub fn stop(self) {
        drop(self);
    }

    fn notify_state(&self) {
        (self.events)(SessionEvent::StateChanged { state: self.state });
    }
}
