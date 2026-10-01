use std::sync::Arc;

use flutter_rust_bridge::frb;

use crate::error::AzaharError;
use crate::registry;
pub use crate::session::{SessionEvent, SessionOptions, SessionState, ShaderStage};

#[frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_backtrace();
}

/// Starts a game and streams its events (shader progress, textures, state
/// changes, errors) to Dart.
pub fn start_game(
    game_path: String,
    options: SessionOptions,
    events: crate::frb_generated::StreamSink<SessionEvent>,
) -> Result<(), AzaharError> {
    registry::start(
        &game_path,
        &options,
        Arc::new(move |event| {
            let _ = events.add(event);
        }),
    )
}

pub fn pause_game() -> Result<(), AzaharError> {
    registry::with_session(|session| session.pause())
}

pub fn resume_game() -> Result<(), AzaharError> {
    registry::with_session(|session| session.resume())
}

/// Stops the game and returns after all of its resources have been freed.
pub fn stop_game() -> Result<(), AzaharError> {
    registry::stop()
}

pub fn set_volume(volume: f32) -> Result<(), AzaharError> {
    registry::with_session(|session| {
        session.set_volume(volume);
        Ok(())
    })
}

/// Reads `len` bytes of 3DS memory starting at the virtual address `address`.
pub fn read_memory(address: u32, len: u32) -> Result<Vec<u8>, AzaharError> {
    registry::with_session(|session| session.memory().read_block(address, len as usize))
}

pub fn read_u32(address: u32) -> Result<u32, AzaharError> {
    registry::with_session(|session| session.memory().read_u32(address))
}

pub fn fcram_size() -> Result<u64, AzaharError> {
    registry::with_session(|session| Ok(session.memory().fcram_size() as u64))
}

pub fn dump_fcram() -> Result<Vec<u8>, AzaharError> {
    registry::with_session(|session| session.memory().dump_fcram())
}
