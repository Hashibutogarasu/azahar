//! Every file the C++ core reads or writes goes through this module, so the core has no platform
//! specific storage code of its own.

mod abi;
mod native;
#[cfg(target_os = "android")]
mod saf;

use std::ffi::CString;
use std::os::fd::RawFd;
use std::path::PathBuf;
use std::sync::RwLock;

use crate::error::{AzaharError, Result};

/// Folders the core expects in a user directory before it first runs, since it does not create
/// the folders of its settings and logs by itself.
const USER_DIRECTORIES: [&str; 6] = ["config", "nand", "sdmc", "sysdata", "cheats", "log"];

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
