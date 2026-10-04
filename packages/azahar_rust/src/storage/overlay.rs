//! Keeps the files a game changes in memory until the application decides to save or discard
//! them, so that writing a save during emulation never waits for the storage.

use std::collections::{BTreeSet, HashMap};
use std::ffi::CString;
use std::fs::File;
use std::io;
use std::os::fd::{AsRawFd, FromRawFd, RawFd};
use std::sync::{Mutex, MutexGuard};

use super::{OpenMode, Storage, storage_for};

/// A file the game only reads and that is larger than this is read from the storage directly,
/// so that installed titles and other large contents are never copied into memory.
const PASSTHROUGH_SIZE: u64 = 32 * 1024 * 1024;

const READ: OpenMode = OpenMode {
    read: true,
    write: false,
    append: false,
    truncate: false,
};

const WRITE: OpenMode = OpenMode {
    read: false,
    write: true,
    append: false,
    truncate: true,
};

/// The state of a path that differs from the storage.
enum Entry {
    /// The contents of the file, held in an anonymous memory file. `dirty` is set once the game
    /// opened it for writing.
    File { file: File, dirty: bool },
    /// A folder created during the session.
    Directory,
    /// A file or folder removed during the session.
    Deleted,
}

#[derive(Clone, Copy, PartialEq, Eq)]
enum Kind {
    Missing,
    File,
    Directory,
}

/// The files and folders changed during a session, laid over the storage.
///
/// Every path the overlay has no entry for is answered by the storage, so the overlay only holds
/// the files the game opened and the changes it made.
#[derive(Default)]
pub struct Overlay {
    entries: Mutex<HashMap<String, Entry>>,
}

impl Overlay {
    fn lock(&self) -> MutexGuard<'_, HashMap<String, Entry>> {
        self.entries
            .lock()
            .unwrap_or_else(|poisoned| poisoned.into_inner())
    }

    /// Writes every change to the storage and returns the paths that could not be written.
    ///
    /// Removals run first, deepest path first, so that a folder replaced by a file of the same
    /// name is gone before the file is written. Folders are created before the files in them.
    pub fn commit(&self) -> Vec<String> {
        let mut entries = self.lock();
        let mut paths: Vec<String> = entries.keys().cloned().collect();
        paths.sort_by_key(|path| (depth(path), path.clone()));
        let mut failed = Vec::new();

        for path in paths.iter().rev() {
            if !matches!(entries.get(path), Some(Entry::Deleted)) {
                continue;
            }
            let backend = storage_for(path);
            let removed = if backend.is_directory(path) {
                backend.remove_dir(path)
            } else if backend.exists(path) {
                backend.remove_file(path)
            } else {
                true
            };
            if !removed {
                failed.push(path.clone());
            }
        }

        for path in &paths {
            if matches!(entries.get(path), Some(Entry::Directory))
                && !storage_for(path).create_dir(path)
            {
                failed.push(path.clone());
            }
        }

        for path in &paths {
            if let Some(Entry::File { file, dirty }) = entries.get_mut(path) {
                if !*dirty {
                    continue;
                }
                if write_back(file, path).is_some() {
                    *dirty = false;
                } else {
                    failed.push(path.clone());
                }
            }
        }
        failed
    }

    fn transfer(&self, from: &str, to: &str, keep_source: bool) -> bool {
        let mut entries = self.lock();
        if kind(&entries, from) != Kind::File
            || kind(&entries, parent(to)) != Kind::Directory
            || kind(&entries, to) == Kind::Directory
        {
            return false;
        }
        let in_memory = matches!(entries.get(from), Some(Entry::File { .. }));
        let file = if !in_memory {
            load(from)
        } else if keep_source {
            match entries.get(from) {
                Some(Entry::File { file, .. }) => duplicate(file),
                _ => None,
            }
        } else {
            match entries.remove(from) {
                Some(Entry::File { file, .. }) => Some(file),
                _ => None,
            }
        };
        let Some(file) = file else {
            return false;
        };
        if !keep_source {
            entries.insert(from.to_owned(), Entry::Deleted);
        }
        entries.insert(to.to_owned(), Entry::File { file, dirty: true });
        true
    }
}

impl Storage for Overlay {
    fn exists(&self, path: &str) -> bool {
        let path = normalize(path);
        kind(&self.lock(), &path) != Kind::Missing
    }

    fn is_directory(&self, path: &str) -> bool {
        let path = normalize(path);
        kind(&self.lock(), &path) == Kind::Directory
    }

    fn size(&self, path: &str) -> u64 {
        let path = normalize(path);
        match self.lock().get(&path) {
            Some(Entry::File { file, .. }) => file.metadata().map_or(0, |metadata| metadata.len()),
            Some(_) => 0,
            None => storage_for(&path).size(&path),
        }
    }

    fn create_dir(&self, path: &str) -> bool {
        let path = normalize(path);
        let mut entries = self.lock();
        match kind(&entries, &path) {
            Kind::Directory => return true,
            Kind::File => return false,
            Kind::Missing => {}
        }
        if kind(&entries, parent(&path)) != Kind::Directory {
            return false;
        }
        entries.insert(path, Entry::Directory);
        true
    }

    fn remove_file(&self, path: &str) -> bool {
        let path = normalize(path);
        let mut entries = self.lock();
        if kind(&entries, &path) != Kind::File {
            return false;
        }
        entries.insert(path, Entry::Deleted);
        true
    }

    fn remove_dir(&self, path: &str) -> bool {
        let path = normalize(path);
        let mut entries = self.lock();
        if kind(&entries, &path) != Kind::Directory
            || !list_in(&entries, &path).is_some_and(|names| names.is_empty())
        {
            return false;
        }
        entries.insert(path, Entry::Deleted);
        true
    }

    /// Moves a folder by moving each entry in it, because a folder only exists in the overlay as
    /// the entries under its path.
    fn rename(&self, from: &str, to: &str) -> bool {
        let (from, to) = (normalize(from), normalize(to));
        let from_kind = kind(&self.lock(), &from);
        match from_kind {
            Kind::Missing => false,
            Kind::File => self.transfer(&from, &to, false),
            Kind::Directory => {
                if !self.create_dir(&to) {
                    return false;
                }
                let Some(names) = self.list(&from) else {
                    return false;
                };
                names
                    .iter()
                    .all(|name| self.rename(&join(&from, name), &join(&to, name)))
                    && self.remove_dir(&from)
            }
        }
    }

    fn copy(&self, from: &str, to: &str) -> bool {
        self.transfer(&normalize(from), &normalize(to), true)
    }

    /// Returns a descriptor of its own for the file in memory, so that each caller keeps its own
    /// offset. A file is read into memory the first time it is opened.
    fn open(&self, path: &str, mode: OpenMode) -> Option<RawFd> {
        let path = normalize(path);
        let mut entries = self.lock();
        if !matches!(entries.get(&path), Some(Entry::File { .. })) {
            match kind(&entries, &path) {
                Kind::Directory => return None,
                Kind::Missing => {
                    if !mode.creates() || kind(&entries, parent(&path)) != Kind::Directory {
                        return None;
                    }
                    let file = memory_file()?;
                    entries.insert(path.clone(), Entry::File { file, dirty: true });
                }
                Kind::File => {
                    let backend = storage_for(&path);
                    if !mode.write && backend.size(&path) > PASSTHROUGH_SIZE {
                        return backend.open(&path, mode);
                    }
                    let file = load(&path)?;
                    entries.insert(path.clone(), Entry::File { file, dirty: false });
                }
            }
        }
        let Some(Entry::File { file, dirty }) = entries.get_mut(&path) else {
            return None;
        };
        let descriptor = reopen(file, mode)?;
        if mode.write {
            *dirty = true;
        }
        Some(descriptor)
    }

    fn list(&self, path: &str) -> Option<Vec<String>> {
        let path = normalize(path);
        list_in(&self.lock(), &path)
    }
}

/// What `path` is, after the changes of the session.
fn kind(entries: &HashMap<String, Entry>, path: &str) -> Kind {
    match entries.get(path) {
        Some(Entry::File { .. }) => Kind::File,
        Some(Entry::Directory) => Kind::Directory,
        Some(Entry::Deleted) => Kind::Missing,
        None => {
            let backend = storage_for(path);
            if backend.is_directory(path) {
                Kind::Directory
            } else if backend.exists(path) {
                Kind::File
            } else {
                Kind::Missing
            }
        }
    }
}

/// The names in the folder `path`: those in the storage, without the removed ones and with the
/// ones created during the session.
fn list_in(entries: &HashMap<String, Entry>, path: &str) -> Option<Vec<String>> {
    let stored = match entries.get(path) {
        Some(Entry::Directory) => storage_for(path).list(path).unwrap_or_default(),
        Some(_) => return None,
        None => {
            let backend = storage_for(path);
            if !backend.is_directory(path) {
                return None;
            }
            backend.list(path)?
        }
    };
    let mut names: BTreeSet<String> = stored.into_iter().collect();
    let prefix = if path.ends_with('/') {
        path.to_owned()
    } else {
        format!("{path}/")
    };
    for (key, entry) in entries {
        let Some(name) = key.strip_prefix(&prefix) else {
            continue;
        };
        if name.is_empty() || name.contains('/') {
            continue;
        }
        match entry {
            Entry::Deleted => {
                names.remove(name);
            }
            _ => {
                names.insert(name.to_owned());
            }
        }
    }
    Some(names.into_iter().collect())
}

/// Creates an anonymous file in memory. The system call is made directly so that it does not
/// depend on the API level of the C library on Android.
fn memory_file() -> Option<File> {
    let name = c"azahar-storage";
    let fd = unsafe { libc::syscall(libc::SYS_memfd_create, name.as_ptr(), libc::MFD_CLOEXEC) };
    if fd < 0 {
        return None;
    }
    Some(unsafe { File::from_raw_fd(fd as RawFd) })
}

/// Opens the memory file again through `/proc`, which, unlike `dup`, gives the new descriptor an
/// offset of its own.
fn reopen(file: &File, mode: OpenMode) -> Option<RawFd> {
    let access = match (mode.read, mode.write) {
        (true, true) => libc::O_RDWR,
        (false, true) => libc::O_WRONLY,
        _ => libc::O_RDONLY,
    };
    let mut flags = access | libc::O_CLOEXEC;
    if mode.append {
        flags |= libc::O_APPEND;
    }
    if mode.truncate {
        flags |= libc::O_TRUNC;
    }
    let path = CString::new(format!("/proc/self/fd/{}", file.as_raw_fd())).ok()?;
    let fd = unsafe { libc::open(path.as_ptr(), flags) };
    (fd >= 0).then_some(fd)
}

/// Reads the file at `path` in the storage into memory.
fn load(path: &str) -> Option<File> {
    let fd = storage_for(path).open(path, READ)?;
    let mut source = unsafe { File::from_raw_fd(fd) };
    let mut file = memory_file()?;
    io::copy(&mut source, &mut file).ok()?;
    Some(file)
}

/// Copies a file in memory into a new one.
fn duplicate(file: &File) -> Option<File> {
    let mut source = unsafe { File::from_raw_fd(reopen(file, READ)?) };
    let mut copy = memory_file()?;
    io::copy(&mut source, &mut copy).ok()?;
    Some(copy)
}

/// Writes a file in memory to `path` in the storage, replacing what is there.
fn write_back(file: &File, path: &str) -> Option<()> {
    let mut source = unsafe { File::from_raw_fd(reopen(file, READ)?) };
    let mut target = unsafe { File::from_raw_fd(storage_for(path).open(path, WRITE)?) };
    io::copy(&mut source, &mut target).ok()?;
    Some(())
}

/// Removes repeated and trailing separators, because the core joins paths without checking for
/// them and the overlay keys its entries by path.
pub(super) fn normalize(path: &str) -> String {
    let mut normalized = String::with_capacity(path.len());
    for character in path.chars() {
        if character == '/' && normalized.ends_with('/') {
            continue;
        }
        normalized.push(character);
    }
    if normalized.len() > 1 && normalized.ends_with('/') {
        normalized.pop();
    }
    normalized
}

fn parent(path: &str) -> &str {
    match path.rfind('/') {
        Some(0) => "/",
        Some(index) => &path[..index],
        None => "",
    }
}

fn join(folder: &str, name: &str) -> String {
    if folder.ends_with('/') {
        format!("{folder}{name}")
    } else {
        format!("{folder}/{name}")
    }
}

fn depth(path: &str) -> usize {
    path.matches('/').count()
}
