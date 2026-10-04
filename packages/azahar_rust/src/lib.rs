//! Rust-owned 3DS game session, memory access, audio output and file storage.
//!
//! The C++ core is reached only through the C ABI declared in
//! `include/azahar_session.h`, and it reaches the storage of the crate through the one declared
//! in `include/azahar_storage.h`. The unsafe surface is confined to [`ffi`] and the storage ABI.

pub mod api;
pub mod audio;
pub mod error;
mod ffi;
mod frb_generated;
mod library;
pub mod memory;
mod raw;
pub mod registry;
pub mod session;
mod storage;
