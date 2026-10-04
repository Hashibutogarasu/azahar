use std::ffi::{CStr, CString, c_char, c_void};

use super::{OpenMode, set_root, storage_for, with_state};

type EntryCallback = unsafe extern "C" fn(*mut c_void, *const c_char);

#[repr(C)]
pub struct AzaharStorageApi {
    exists: unsafe extern "C" fn(*const c_char) -> i32,
    is_directory: unsafe extern "C" fn(*const c_char) -> i32,
    size: unsafe extern "C" fn(*const c_char) -> u64,
    create_dir: unsafe extern "C" fn(*const c_char) -> i32,
    remove_file: unsafe extern "C" fn(*const c_char) -> i32,
    remove_dir: unsafe extern "C" fn(*const c_char) -> i32,
    rename: unsafe extern "C" fn(*const c_char, *const c_char) -> i32,
    copy: unsafe extern "C" fn(*const c_char, *const c_char) -> i32,
    open: unsafe extern "C" fn(*const c_char, *const c_char) -> i32,
    list: unsafe extern "C" fn(*const c_char, *mut c_void, Option<EntryCallback>) -> i32,
    user_path: unsafe extern "C" fn() -> *const c_char,
    set_root: unsafe extern "C" fn(*const c_char) -> i32,
}

static API: AzaharStorageApi = AzaharStorageApi {
    exists,
    is_directory,
    size,
    create_dir,
    remove_file,
    remove_dir,
    rename,
    copy,
    open,
    list,
    user_path,
    set_root: set_root_raw,
};

#[unsafe(no_mangle)]
pub extern "C" fn azahar_storage_api() -> *const AzaharStorageApi {
    &API
}

unsafe fn text<'a>(value: *const c_char) -> Option<&'a str> {
    if value.is_null() {
        return None;
    }
    unsafe { CStr::from_ptr(value) }.to_str().ok()
}

unsafe extern "C" fn exists(path: *const c_char) -> i32 {
    unsafe { text(path) }.is_some_and(|path| storage_for(path).exists(path)) as i32
}

unsafe extern "C" fn is_directory(path: *const c_char) -> i32 {
    unsafe { text(path) }.is_some_and(|path| storage_for(path).is_directory(path)) as i32
}

unsafe extern "C" fn size(path: *const c_char) -> u64 {
    unsafe { text(path) }.map_or(0, |path| storage_for(path).size(path))
}

unsafe extern "C" fn create_dir(path: *const c_char) -> i32 {
    unsafe { text(path) }.is_some_and(|path| storage_for(path).create_dir(path)) as i32
}

unsafe extern "C" fn remove_file(path: *const c_char) -> i32 {
    unsafe { text(path) }.is_some_and(|path| storage_for(path).remove_file(path)) as i32
}

unsafe extern "C" fn remove_dir(path: *const c_char) -> i32 {
    unsafe { text(path) }.is_some_and(|path| storage_for(path).remove_dir(path)) as i32
}

unsafe extern "C" fn rename(from: *const c_char, to: *const c_char) -> i32 {
    match unsafe { (text(from), text(to)) } {
        (Some(from), Some(to)) => storage_for(from).rename(from, to) as i32,
        _ => 0,
    }
}

unsafe extern "C" fn copy(from: *const c_char, to: *const c_char) -> i32 {
    match unsafe { (text(from), text(to)) } {
        (Some(from), Some(to)) => storage_for(from).copy(from, to) as i32,
        _ => 0,
    }
}

unsafe extern "C" fn open(path: *const c_char, mode: *const c_char) -> i32 {
    let (Some(path), Some(mode)) = (unsafe { text(path) }, unsafe { text(mode) }) else {
        return -1;
    };
    let Some(mode) = OpenMode::parse(mode) else {
        return -1;
    };
    storage_for(path).open(path, mode).unwrap_or(-1)
}

unsafe extern "C" fn list(
    path: *const c_char,
    user: *mut c_void,
    callback: Option<EntryCallback>,
) -> i32 {
    let (Some(path), Some(callback)) = (unsafe { text(path) }, callback) else {
        return 0;
    };
    let Some(names) = storage_for(path).list(path) else {
        return 0;
    };
    for name in names {
        if let Ok(name) = CString::new(name) {
            unsafe { callback(user, name.as_ptr()) };
        }
    }
    1
}

unsafe extern "C" fn user_path() -> *const c_char {
    with_state(|state| state.user_path.as_ptr())
}

unsafe extern "C" fn set_root_raw(location: *const c_char) -> i32 {
    unsafe { text(location) }.is_some_and(|location| set_root(location).is_ok()) as i32
}
