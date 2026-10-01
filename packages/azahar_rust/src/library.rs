//! The C++ core and the way it is made available to a session.
//!
//! Where the core is linked into the executable, its functions are called directly. Where it is
//! a shared library of its own, the library is loaded for the session and unloaded when the
//! session ends, which destroys every global the core created.

use crate::error::AzaharError;
use crate::raw::CoreApi;

/// Why the core could not be opened, and the library that has to be closed because of it.
pub struct OpenFailure {
    pub error: AzaharError,
    /// The handle to pass to [`close`], or 0 when nothing was loaded.
    pub handle: usize,
}

/// The core as one session sees it.
///
/// Dropping it makes the core release what it started on its own and detaches it from the
/// application. It must be dropped on the thread that created it. The library itself is
/// unloaded by [`close`] afterwards, once that thread has ended, so no destructor of a
/// thread-local of the library runs after the library is gone.
pub struct CoreLibrary {
    pub api: CoreApi,
    unload: Unload,
}

impl CoreLibrary {
    pub fn open() -> Result<Self, OpenFailure> {
        let (api, unload) = platform::open()?;
        Ok(Self { api, unload })
    }

    /// The handle to pass to [`close`], or 0 when there is nothing to unload.
    pub fn handle(&self) -> usize {
        self.unload.handle()
    }
}

/// Unloads the library behind `handle`, which [`CoreLibrary::handle`] returned.
pub fn close(handle: usize) {
    platform::close(handle);
}

use platform::Unload;

#[cfg(not(target_os = "android"))]
mod platform {
    use super::OpenFailure;
    use crate::raw::{CoreApi, RawCallbacks, RawOptions, RawSession};
    use std::ffi::c_char;

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

    /// The core is part of the executable, so there is nothing to unload.
    pub struct Unload;

    impl Unload {
        pub fn handle(&self) -> usize {
            0
        }
    }

    pub fn close(_handle: usize) {}

    pub fn open() -> Result<(CoreApi, Unload), OpenFailure> {
        let api = CoreApi {
            create: azahar_session_create,
            start: azahar_session_start,
            pause: azahar_session_pause,
            resume: azahar_session_resume,
            fcram_size: azahar_session_fcram_size,
            read_memory: azahar_session_read_memory,
            read_fcram: azahar_session_read_fcram,
            destroy: azahar_session_destroy,
        };
        Ok((api, Unload))
    }
}

#[cfg(target_os = "android")]
mod platform {
    use super::OpenFailure;
    use crate::error::AzaharError;
    use crate::raw::{CoreApi, STATUS_OK};
    use std::ffi::{CStr, c_char, c_int, c_void};
    use std::mem::transmute;

    const LIBRARY_NAME: &CStr = c"libazahar-session.so";

    unsafe extern "C" {
        fn dlopen(filename: *const c_char, flags: c_int) -> *mut c_void;
        fn dlsym(handle: *mut c_void, symbol: *const c_char) -> *mut c_void;
        fn dlclose(handle: *mut c_void) -> c_int;
        fn dlerror() -> *const c_char;

        fn azahar_host_java_vm() -> *mut c_void;
        fn azahar_host_class_loader() -> *mut c_void;
        fn azahar_host_state() -> *const c_void;
        fn azahar_host_bind_natives(session_library: *mut c_void);
        fn azahar_host_unbind_natives();
    }

    const RTLD_NOW: c_int = 2;
    const RTLD_LOCAL: c_int = 0;

    type InitFn = unsafe extern "C" fn(*mut c_void, *mut c_void, *const c_void) -> i32;
    type ShutdownFn = unsafe extern "C" fn();

    /// Detaches the library of the session from the application.
    ///
    /// The methods of the application that were bound to the library are bound back first, then
    /// the library releases what it started on its own. It is unloaded by [`close`].
    pub struct Unload {
        handle: *mut c_void,
        shutdown: ShutdownFn,
    }

    impl Unload {
        pub fn handle(&self) -> usize {
            self.handle as usize
        }
    }

    impl Drop for Unload {
        fn drop(&mut self) {
            unsafe {
                azahar_host_unbind_natives();
                (self.shutdown)();
            }
        }
    }

    pub fn close(handle: usize) {
        if handle != 0 {
            unsafe { dlclose(handle as *mut c_void) };
        }
    }

    fn last_error() -> String {
        let message = unsafe { dlerror() };
        if message.is_null() {
            return "unknown error".into();
        }
        unsafe { CStr::from_ptr(message) }
            .to_string_lossy()
            .into_owned()
    }

    unsafe fn symbol(handle: *mut c_void, name: &CStr) -> Result<*mut c_void, AzaharError> {
        let address = unsafe { dlsym(handle, name.as_ptr()) };
        if address.is_null() {
            return Err(AzaharError::LibraryLoad(format!(
                "{} is missing: {}",
                name.to_string_lossy(),
                last_error()
            )));
        }
        Ok(address)
    }

    pub fn open() -> Result<(CoreApi, Unload), OpenFailure> {
        let handle = unsafe { dlopen(LIBRARY_NAME.as_ptr(), RTLD_NOW | RTLD_LOCAL) };
        if handle.is_null() {
            return Err(OpenFailure {
                error: AzaharError::LibraryLoad(last_error()),
                handle: 0,
            });
        }

        unsafe { load(handle) }.map_err(|error| OpenFailure {
            error,
            handle: handle as usize,
        })
    }

    unsafe fn init_failure(handle: *mut c_void, status: i32) -> AzaharError {
        let reason = unsafe { dlsym(handle, c"azahar_session_lib_last_error".as_ptr()) };
        if reason.is_null() {
            return AzaharError::LibraryLoad(format!(
                "the library failed to initialize with status {status}"
            ));
        }
        let reason: unsafe extern "C" fn() -> *const c_char = unsafe { transmute(reason) };
        let reason = unsafe { CStr::from_ptr(reason()) }.to_string_lossy();
        AzaharError::LibraryLoad(format!(
            "the library failed to initialize with status {status}: {reason}"
        ))
    }

    unsafe fn load(handle: *mut c_void) -> Result<(CoreApi, Unload), AzaharError> {
        unsafe {
            let init: InitFn = transmute(symbol(handle, c"azahar_session_lib_init")?);
            let shutdown: ShutdownFn = transmute(symbol(handle, c"azahar_session_lib_shutdown")?);
            let api = CoreApi {
                create: transmute(symbol(handle, c"azahar_session_create")?),
                start: transmute(symbol(handle, c"azahar_session_start")?),
                pause: transmute(symbol(handle, c"azahar_session_pause")?),
                resume: transmute(symbol(handle, c"azahar_session_resume")?),
                fcram_size: transmute(symbol(handle, c"azahar_session_fcram_size")?),
                read_memory: transmute(symbol(handle, c"azahar_session_read_memory")?),
                read_fcram: transmute(symbol(handle, c"azahar_session_read_fcram")?),
                destroy: transmute(symbol(handle, c"azahar_session_destroy")?),
            };

            let status = init(
                azahar_host_java_vm(),
                azahar_host_class_loader(),
                azahar_host_state(),
            );
            if status != STATUS_OK {
                return Err(init_failure(handle, status));
            }
            azahar_host_bind_natives(handle);
            Ok((api, Unload { handle, shutdown }))
        }
    }
}
