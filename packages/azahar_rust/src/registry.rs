//! Process-wide ownership of the single active session.

use std::sync::{Mutex, MutexGuard};

use crate::error::{AzaharError, Result};
use crate::session::{EventSink, GameSession, SessionOptions};

static LIFECYCLE: Mutex<()> = Mutex::new(());
static ACTIVE: Mutex<Option<GameSession>> = Mutex::new(None);

fn lock<T>(mutex: &Mutex<T>) -> MutexGuard<'_, T> {
    mutex.lock().unwrap_or_else(|poisoned| poisoned.into_inner())
}

/// Starts a session. Fails while another one is alive.
///
/// Holding the lifecycle lock makes a start wait for a concurrent stop to
/// finish releasing its resources.
pub fn start(game_path: &str, options: &SessionOptions, events: EventSink) -> Result<()> {
    let _lifecycle = lock(&LIFECYCLE);
    if lock(&ACTIVE).is_some() {
        return Err(AzaharError::SessionActive);
    }
    let session = GameSession::start(game_path, options, events)?;
    *lock(&ACTIVE) = Some(session);
    Ok(())
}

/// Stops the active session and returns once all of its resources are freed.
pub fn stop() -> Result<()> {
    let _lifecycle = lock(&LIFECYCLE);
    let session = lock(&ACTIVE).take().ok_or(AzaharError::NoSession)?;
    session.stop();
    Ok(())
}

/// Runs `operation` against the active session.
pub fn with_session<R>(operation: impl FnOnce(&mut GameSession) -> Result<R>) -> Result<R> {
    let mut active = lock(&ACTIVE);
    let session = active.as_mut().ok_or(AzaharError::NoSession)?;
    operation(session)
}
