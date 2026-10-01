use thiserror::Error;

/// Errors surfaced by the session API.
#[derive(Debug, Error)]
pub enum AzaharError {
    /// A session is still alive, so a second one cannot be started.
    #[error("a game session is already active")]
    SessionActive,
    /// The operation needs a session but none is active.
    #[error("no game session is active")]
    NoSession,
    /// The game path contains an interior NUL byte.
    #[error("the game path is invalid")]
    InvalidPath,
    /// The C++ core refused to create the session.
    #[error("the core failed to create the session")]
    CreateFailed,
    /// The operation is not valid in the current session state.
    #[error("the session is not in a state that allows this operation")]
    InvalidState,
    /// The core returned a non-zero status code.
    #[error("the core reported status {0}")]
    Core(i32),
    /// The requested 3DS address range is not mapped.
    #[error("the 3DS memory range {address:#010x}+{len} is not mapped")]
    InvalidAddress { address: u32, len: u32 },
    /// The audio output could not be opened.
    #[error("audio output failed: {0}")]
    Audio(String),
}

/// Result alias used across the crate.
pub type Result<T> = std::result::Result<T, AzaharError>;
