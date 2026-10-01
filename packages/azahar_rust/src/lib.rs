//! Rust-owned 3DS game session, memory access and audio output.
//!
//! The C++ core is reached only through the C ABI declared in
//! `include/azahar_session.h`. The unsafe surface is confined to [`ffi`].

pub mod api;
pub mod audio;
pub mod error;
mod ffi;
mod frb_generated;
pub mod memory;
pub mod registry;
pub mod session;
