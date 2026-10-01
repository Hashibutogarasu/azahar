//! The only module that touches the C ABI of the C++ core.

use std::ffi::{CStr, CString, c_char, c_void};
use std::ptr::NonNull;
use std::sync::Arc;

use crate::error::{AzaharError, Result};
use crate::session::{SessionEvent, SessionOptions, ShaderStage};

const STATUS_OK: i32 = 0;
const STATUS_INVALID_ADDRESS: i32 = 4;

#[repr(C)]
struct RawSession {
    _private: [u8; 0],
}

#[repr(C)]
struct RawCallbacks {
    user: *mut c_void,
    on_shader_progress: Option<unsafe extern "C" fn(*mut c_void, i32, u64, u64)>,
    on_texture: Option<unsafe extern "C" fn(*mut c_void, i64, i32)>,
    on_error: Option<unsafe extern "C" fn(*mut c_void, *const c_char)>,
    on_audio: Option<unsafe extern "C" fn(*mut c_void, *const i16, usize)>,
}

#[repr(C)]
struct RawOptions {
    primary_width: i32,
    primary_height: i32,
    secondary_width: i32,
    secondary_height: i32,
    dual_screen: i32,
}

unsafe extern "C" {
    fn azahar_session_create(
        game_path: *const c_char,
        options: *const RawOptions,
        callbacks: *const RawCallbacks,
    ) -> *mut RawSession;
    fn azahar_session_start(session: *mut RawSession) -> i32;
    fn azahar_session_pause(session: *mut RawSession) -> i32;
    fn azahar_session_resume(session: *mut RawSession) -> i32;
    fn azahar_session_fcram_size(session: *const RawSession) -> usize;
    fn azahar_session_read_memory(
        session: *mut RawSession,
        address: u32,
        out: *mut u8,
        len: usize,
    ) -> i32;
    fn azahar_session_read_fcram(
        session: *mut RawSession,
        offset: usize,
        out: *mut u8,
        len: usize,
    ) -> i32;
    fn azahar_session_destroy(session: *mut RawSession);
}

/// Receiver of everything the core reports from its own threads.
pub trait CoreListener: Send + Sync {
    fn on_event(&self, event: SessionEvent);
    fn on_audio(&self, frames: &[i16]);
}

/// Heap allocated state the core keeps a raw pointer to.
///
/// It must outlive the [`SessionHandle`] that was created with it.
pub struct CallbackContext {
    listener: Arc<dyn CoreListener>,
}

impl CallbackContext {
    pub fn new(listener: Arc<dyn CoreListener>) -> Box<Self> {
        Box::new(Self { listener })
    }
}

unsafe fn context<'a>(user: *mut c_void) -> &'a CallbackContext {
    unsafe { &*(user as *const CallbackContext) }
}

unsafe extern "C" fn trampoline_shader_progress(
    user: *mut c_void,
    stage: i32,
    progress: u64,
    max: u64,
) {
    let stage = match stage {
        0 => ShaderStage::Prepare,
        1 => ShaderStage::Decompile,
        2 => ShaderStage::Build,
        _ => ShaderStage::Complete,
    };
    unsafe { context(user) }
        .listener
        .on_event(SessionEvent::ShaderProgress {
            stage,
            progress,
            max,
        });
}

unsafe extern "C" fn trampoline_texture(user: *mut c_void, texture_id: i64, secondary: i32) {
    unsafe { context(user) }
        .listener
        .on_event(SessionEvent::Texture {
            texture_id,
            secondary: secondary != 0,
        });
}

unsafe extern "C" fn trampoline_error(user: *mut c_void, message: *const c_char) {
    let message = if message.is_null() {
        String::new()
    } else {
        unsafe { CStr::from_ptr(message) }
            .to_string_lossy()
            .into_owned()
    };
    unsafe { context(user) }
        .listener
        .on_event(SessionEvent::Error { message });
}

unsafe extern "C" fn trampoline_audio(user: *mut c_void, frames: *const i16, frame_count: usize) {
    if frames.is_null() || frame_count == 0 {
        return;
    }
    let samples = unsafe { std::slice::from_raw_parts(frames, frame_count * 2) };
    unsafe { context(user) }.listener.on_audio(samples);
}

/// Owning handle to one core session.
///
/// Dropping it calls `azahar_session_destroy`, which joins every core thread
/// and frees the emulated 3DS memory before returning.
pub struct SessionHandle {
    raw: NonNull<RawSession>,
}

unsafe impl Send for SessionHandle {}

impl SessionHandle {
    /// Creates a core session that reports through `context`.
    ///
    /// The caller keeps `context` alive for at least as long as the handle.
    pub fn create(
        game_path: &str,
        options: &SessionOptions,
        context: &CallbackContext,
    ) -> Result<Self> {
        let path = CString::new(game_path).map_err(|_| AzaharError::InvalidPath)?;
        let raw_options = RawOptions {
            primary_width: options.primary_width,
            primary_height: options.primary_height,
            secondary_width: options.secondary_width,
            secondary_height: options.secondary_height,
            dual_screen: options.dual_screen as i32,
        };
        let callbacks = RawCallbacks {
            user: context as *const CallbackContext as *mut c_void,
            on_shader_progress: Some(trampoline_shader_progress),
            on_texture: Some(trampoline_texture),
            on_error: Some(trampoline_error),
            on_audio: Some(trampoline_audio),
        };
        let raw = unsafe { azahar_session_create(path.as_ptr(), &raw_options, &callbacks) };
        NonNull::new(raw)
            .map(|raw| Self { raw })
            .ok_or(AzaharError::CreateFailed)
    }

    pub fn start(&self) -> Result<()> {
        check(unsafe { azahar_session_start(self.raw.as_ptr()) })
    }

    pub fn pause(&self) -> Result<()> {
        check(unsafe { azahar_session_pause(self.raw.as_ptr()) })
    }

    pub fn resume(&self) -> Result<()> {
        check(unsafe { azahar_session_resume(self.raw.as_ptr()) })
    }

    pub fn fcram_size(&self) -> usize {
        unsafe { azahar_session_fcram_size(self.raw.as_ptr()) }
    }

    pub fn read_memory(&self, address: u32, out: &mut [u8]) -> Result<()> {
        let status = unsafe {
            azahar_session_read_memory(self.raw.as_ptr(), address, out.as_mut_ptr(), out.len())
        };
        if status == STATUS_INVALID_ADDRESS {
            return Err(AzaharError::InvalidAddress {
                address,
                len: out.len() as u32,
            });
        }
        check(status)
    }

    pub fn read_fcram(&self, offset: usize, out: &mut [u8]) -> Result<()> {
        check(unsafe {
            azahar_session_read_fcram(self.raw.as_ptr(), offset, out.as_mut_ptr(), out.len())
        })
    }
}

impl Drop for SessionHandle {
    fn drop(&mut self) {
        unsafe { azahar_session_destroy(self.raw.as_ptr()) };
    }
}

fn check(status: i32) -> Result<()> {
    if status == STATUS_OK {
        Ok(())
    } else {
        Err(AzaharError::Core(status))
    }
}
