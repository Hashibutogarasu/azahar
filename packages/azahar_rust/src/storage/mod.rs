//! Every file the C++ core reads or writes goes through this module, so the core has no platform
//! specific storage code of its own.

mod abi;
mod native;
mod overlay;
#[cfg(target_os = "android")]
mod saf;

use std::ffi::CString;
use std::os::fd::RawFd;
use std::path::PathBuf;
use std::sync::{Arc, RwLock};

use overlay::Overlay;

use crate::error::{AzaharError, Result};

/// Folders the core expects in a user directory before it first runs, since it does not create
/// the folders of its settings and logs by itself.
const USER_DIRECTORIES: [&str; 6] = ["config", "nand", "sdmc", "sysdata", "cheats", "log"];

/// Folders of the user directory whose changes are held in memory during a session. They hold
/// the saves, the system data and the installed titles. Logs and caches are left out, since a
/// log is needed after a crash and a cache is not part of what the user saves or discards.
const OVERLAY_DIRECTORIES: [&str; 3] = ["nand", "sdmc", "sysdata"];

/// A file system the core can reach. The paths are the ones the core uses, so a backend decides
/// on its own how a path maps to its storage.
pub trait Storage: Send + Sync {
    fn exists(&self, path: &str) -> bool;
    fn is_directory(&self, path: &str) -> bool;
    fn size(&self, path: &str) -> u64;
    fn create_dir(&self, path: &str) -> bool;
    fn remove_file(&self, path: &str) -> bool;
    fn remove_dir(&self, path: &str) -> bool;
    fn rename(&self, from: &str, to: &str) -> bool;
    fn copy(&self, from: &str, to: &str) -> bool;
    fn open(&self, path: &str, mode: OpenMode) -> Option<RawFd>;
    fn list(&self, path: &str) -> Option<Vec<String>>;
}

/// An `fopen` mode, kept as flags because each backend opens files in its own way.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct OpenMode {
    pub read: bool,
    pub write: bool,
    pub append: bool,
    pub truncate: bool,
}

impl OpenMode {
    pub fn parse(mode: &str) -> Option<Self> {
        let update = mode.contains('+');
        match mode.chars().next()? {
            'r' => Some(Self {
                read: true,
                write: update,
                append: false,
                truncate: false,
            }),
            'w' => Some(Self {
                read: update,
                write: true,
                append: false,
                truncate: true,
            }),
            'a' => Some(Self {
                read: update,
                write: true,
                append: true,
                truncate: false,
            }),
            _ => None,
        }
    }

    /// `fopen` creates the file for `w` and `a` but not for `r+`.
    pub fn creates(&self) -> bool {
        self.truncate || self.append
    }
}

/// Where the user directory is. A tree of the Storage Access Framework has no path, so the core
/// addresses it by paths relative to `/`.
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum Root {
    Native(PathBuf),
    Tree(String),
}

impl Root {
    pub fn parse(location: &str) -> Option<Self> {
        if let Some(path) = location.strip_prefix("file://") {
            return Some(Self::Native(PathBuf::from(percent_decode(path)?)));
        }
        if location.starts_with("content://") {
            return Some(Self::Tree(location.to_owned()));
        }
        if location.starts_with('/') {
            return Some(Self::Native(PathBuf::from(location)));
        }
        None
    }

    fn user_path(&self) -> String {
        match self {
            Self::Native(path) => {
                let mut path = path.to_string_lossy().into_owned();
                if !path.ends_with('/') {
                    path.push('/');
                }
                path
            }
            Self::Tree(_) => "/".to_owned(),
        }
    }
}

/// Declares, for each platform, the user directory used before one is chosen and the backend
/// that reaches a path. Keeping both in one table keeps the platform differences out of the
/// callers.
macro_rules! platform_storage {
    ($($os:literal => {
        default_root: $default:expr,
        backend: |$path:ident, $root:ident| $select:expr $(,)?
    })+) => {
        $(
            #[cfg(target_os = $os)]
            fn default_root() -> Root {
                $default
            }

            #[cfg(target_os = $os)]
            fn backend($path: &str, $root: &Root) -> &'static dyn Storage {
                $select
            }
        )+
    };
}

platform_storage! {
    "linux" => {
        default_root: Root::Native(native::default_user_directory()),
        backend: |_path, _root| &native::NativeStorage,
    }
    "android" => {
        default_root: Root::Tree(String::new()),
        backend: |path, root| {
            if path.starts_with("content://")
                || (matches!(root, Root::Tree(_)) && path.starts_with('/'))
            {
                &saf::SafStorage
            } else {
                &native::NativeStorage
            }
        },
    }
}

struct State {
    root: Root,
    user_path: CString,
}

impl State {
    fn new(root: Root) -> Self {
        let user_path = CString::new(root.user_path()).unwrap_or_default();
        Self { root, user_path }
    }
}

static STATE: RwLock<Option<State>> = RwLock::new(None);

fn with_state<R>(f: impl FnOnce(&State) -> R) -> R {
    {
        let state = STATE.read().unwrap_or_else(|error| error.into_inner());
        if let Some(state) = state.as_ref() {
            return f(state);
        }
    }
    let mut state = STATE.write().unwrap_or_else(|error| error.into_inner());
    f(state.get_or_insert_with(|| State::new(default_root())))
}

fn storage_for(path: &str) -> &'static dyn Storage {
    with_state(|state| backend(path, &state.root))
}

static OVERLAY: RwLock<Option<Arc<Overlay>>> = RwLock::new(None);

/// The storage that answers for one path: the overlay while a session holds the path in memory,
/// otherwise the backend of the path.
enum Route {
    Overlay(Arc<Overlay>),
    Backend(&'static dyn Storage),
}

impl Route {
    fn storage(&self) -> &dyn Storage {
        match self {
            Self::Overlay(overlay) => overlay.as_ref(),
            Self::Backend(backend) => *backend,
        }
    }
}

/// Whether `path` lies in one of [`OVERLAY_DIRECTORIES`] of the current user directory. The user
/// directory is read on every call, because the core may set it after the session started.
fn in_overlay_directory(path: &str) -> bool {
    let path = overlay::normalize(path);
    with_state(|state| {
        let Ok(user_path) = state.user_path.to_str() else {
            return false;
        };
        OVERLAY_DIRECTORIES.iter().any(|name| {
            let folder = format!("{user_path}{name}");
            path == folder || path.starts_with(&format!("{folder}/"))
        })
    })
}

fn route(path: &str) -> Route {
    route_any(&[path])
}

/// Routes an operation on several paths to the overlay when any of them is held in memory, so
/// that a file moved into or out of an overlay folder is still tracked.
fn route_any(paths: &[&str]) -> Route {
    let overlay = OVERLAY
        .read()
        .unwrap_or_else(|error| error.into_inner())
        .clone();
    match overlay {
        Some(overlay) if paths.iter().any(|path| in_overlay_directory(path)) => {
            Route::Overlay(overlay)
        }
        _ => Route::Backend(storage_for(paths[0])),
    }
}

/// Starts holding the changes to the saves, the system data and the installed titles in memory.
pub fn begin_overlay() {
    *OVERLAY.write().unwrap_or_else(|error| error.into_inner()) =
        Some(Arc::new(Overlay::default()));
}

/// Writes the changes held in memory to the storage. Fails with the paths that could not be
/// written; the other changes are written anyway.
pub fn commit_overlay() -> Result<()> {
    let overlay = OVERLAY
        .read()
        .unwrap_or_else(|error| error.into_inner())
        .clone();
    let Some(overlay) = overlay else {
        return Ok(());
    };
    let failed = overlay.commit();
    if failed.is_empty() {
        Ok(())
    } else {
        Err(AzaharError::StorageCommit(failed))
    }
}

/// Stops holding changes in memory and drops the ones not written, so that every later access
/// reaches the storage again.
pub fn end_overlay() {
    *OVERLAY.write().unwrap_or_else(|error| error.into_inner()) = None;
}

fn set_root(location: &str) -> Result<()> {
    let root = Root::parse(location).ok_or(AzaharError::InvalidPath)?;
    *STATE.write().unwrap_or_else(|error| error.into_inner()) = Some(State::new(root));
    Ok(())
}

/// Creates the folders the core expects in the user directory at `location`, which does not have
/// to be the current one, since a profile is prepared before it is switched to.
pub fn initialize(location: &str) -> Result<()> {
    let root = Root::parse(location).ok_or(AzaharError::InvalidPath)?;
    let base = match &root {
        Root::Native(_) => root.user_path(),
        Root::Tree(uri) => format!("{}/", uri.trim_end_matches('/')),
    };
    if let Root::Native(path) = &root {
        std::fs::create_dir_all(path)
            .map_err(|error| AzaharError::Storage(format!("{}: {error}", path.display())))?;
    }
    for name in USER_DIRECTORIES {
        let path = format!("{base}{name}");
        if !backend(&path, &root).create_dir(&path) {
            return Err(AzaharError::Storage(path));
        }
    }
    Ok(())
}

fn percent_decode(text: &str) -> Option<String> {
    let bytes = text.as_bytes();
    let mut decoded = Vec::with_capacity(bytes.len());
    let mut index = 0;
    while index < bytes.len() {
        if bytes[index] == b'%' {
            let hex = text.get(index + 1..index + 3)?;
            decoded.push(u8::from_str_radix(hex, 16).ok()?);
            index += 3;
        } else {
            decoded.push(bytes[index]);
            index += 1;
        }
    }
    String::from_utf8(decoded).ok()
}
