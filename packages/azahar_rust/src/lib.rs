//! Rust-owned 3DS game session, memory access and audio output.
//!
//! The C++ core is reached only through the C ABI declared in
//! `include/azahar_session.h`. The unsafe surface is confined to [`ffi`].

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
