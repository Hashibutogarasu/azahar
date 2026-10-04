//! The types of the C ABI declared in `include/azahar_session.h`.

use std::ffi::{c_char, c_void};

pub const STATUS_OK: i32 = 0;
pub const STATUS_INVALID_ADDRESS: i32 = 4;

#[repr(C)]
pub struct RawSession {
    _private: [u8; 0],
}

#[repr(C)]
pub struct RawCallbacks {
    pub user: *mut c_void,
    pub on_shader_progress: Option<unsafe extern "C" fn(*mut c_void, i32, u64, u64)>,
    pub on_texture: Option<unsafe extern "C" fn(*mut c_void, i64, i32)>,
    pub on_error: Option<unsafe extern "C" fn(*mut c_void, *const c_char)>,
    pub on_audio: Option<unsafe extern "C" fn(*mut c_void, *const i16, usize)>,
    pub on_shutdown_requested: Option<unsafe extern "C" fn(*mut c_void)>,
}

#[repr(C)]
#[derive(Clone, Copy)]
pub struct RawOptions {
    pub primary_width: i32,
    pub primary_height: i32,
    pub secondary_width: i32,
    pub secondary_height: i32,
    pub dual_screen: i32,
}

/// The functions of the core that a session uses.
#[derive(Clone, Copy)]
pub struct CoreApi {
    pub create: unsafe extern "C" fn(
        *const c_char,
        *const RawOptions,
        *const RawCallbacks,
    ) -> *mut RawSession,
    pub start: unsafe extern "C" fn(*mut RawSession) -> i32,
    pub pause: unsafe extern "C" fn(*mut RawSession) -> i32,
    pub resume: unsafe extern "C" fn(*mut RawSession) -> i32,
    pub fcram_size: unsafe extern "C" fn(*const RawSession) -> usize,
    pub read_memory: unsafe extern "C" fn(*mut RawSession, u32, *mut u8, usize) -> i32,
    pub read_fcram: unsafe extern "C" fn(*mut RawSession, usize, *mut u8, usize) -> i32,
    pub destroy: unsafe extern "C" fn(*mut RawSession),
}
