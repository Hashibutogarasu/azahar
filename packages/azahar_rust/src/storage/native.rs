use std::fs::{self, OpenOptions};
use std::io::ErrorKind;
use std::os::fd::{IntoRawFd, RawFd};
use std::path::{Path, PathBuf};

use super::{OpenMode, Storage};

/// Reaches paths of the file system directly.
pub struct NativeStorage;

impl Storage for NativeStorage {
    fn exists(&self, path: &str) -> bool {
        Path::new(path).exists()
    }

    fn is_directory(&self, path: &str) -> bool {
        Path::new(path).is_dir()
    }

    fn size(&self, path: &str) -> u64 {
        fs::metadata(path)
            .ok()
            .filter(|metadata| metadata.is_file())
            .map_or(0, |metadata| metadata.len())
    }

    fn create_dir(&self, path: &str) -> bool {
        match fs::create_dir(path) {
            Ok(()) => true,
            Err(error) => error.kind() == ErrorKind::AlreadyExists && self.is_directory(path),
        }
    }

    fn remove_file(&self, path: &str) -> bool {
        fs::remove_file(path).is_ok()
    }

    fn remove_dir(&self, path: &str) -> bool {
        fs::remove_dir(path).is_ok()
    }

    fn rename(&self, from: &str, to: &str) -> bool {
        fs::rename(from, to).is_ok()
    }

    fn copy(&self, from: &str, to: &str) -> bool {
        fs::copy(from, to).is_ok()
    }

    fn open(&self, path: &str, mode: OpenMode) -> Option<RawFd> {
        OpenOptions::new()
            .read(mode.read)
            .write(mode.write && !mode.append)
            .append(mode.append)
            .truncate(mode.truncate)
            .create(mode.creates())
            .open(path)
            .ok()
            .map(IntoRawFd::into_raw_fd)
    }

    fn list(&self, path: &str) -> Option<Vec<String>> {
        let entries = fs::read_dir(path).ok()?;
        Some(
            entries
                .filter_map(|entry| entry.ok())
                .map(|entry| entry.file_name().to_string_lossy().into_owned())
                .collect(),
        )
    }
}

/// Follows the XDG base directory specification like the other Linux applications do.
#[cfg_attr(not(target_os = "linux"), allow(dead_code))]
pub fn default_user_directory() -> PathBuf {
    let data_home = std::env::var_os("XDG_DATA_HOME")
        .map(PathBuf::from)
        .filter(|path| path.is_absolute())
        .or_else(|| std::env::var_os("HOME").map(|home| PathBuf::from(home).join(".local/share")))
        .unwrap_or_else(|| PathBuf::from("/tmp"));
    data_home.join("azahar")
}
