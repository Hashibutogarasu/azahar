//! Read access to the emulated 3DS memory.

use crate::error::{AzaharError, Result};
use crate::ffi::SessionHandle;

const DUMP_CHUNK: usize = 1 << 20;

/// A read-only view of the memory of one running session.
///
/// The view borrows the session handle, so the borrow checker guarantees it
/// cannot outlive the session and that the memory is never read after it was
/// freed.
pub struct Memory3ds<'a> {
    handle: &'a SessionHandle,
}

impl<'a> Memory3ds<'a> {
    pub(crate) fn new(handle: &'a SessionHandle) -> Self {
        Self { handle }
    }

    /// Size in bytes of the FCRAM of the running system.
    pub fn fcram_size(&self) -> usize {
        self.handle.fcram_size()
    }

    /// Copies `len` bytes starting at the 3DS virtual address `address`.
    pub fn read_block(&self, address: u32, len: usize) -> Result<Vec<u8>> {
        let mut buffer = vec![0u8; len];
        self.handle.read_memory(address, &mut buffer)?;
        Ok(buffer)
    }

    pub fn read_u8(&self, address: u32) -> Result<u8> {
        Ok(self.read_array::<1>(address)?[0])
    }

    pub fn read_u16(&self, address: u32) -> Result<u16> {
        Ok(u16::from_le_bytes(self.read_array(address)?))
    }

    pub fn read_u32(&self, address: u32) -> Result<u32> {
        Ok(u32::from_le_bytes(self.read_array(address)?))
    }

    pub fn read_u64(&self, address: u32) -> Result<u64> {
        Ok(u64::from_le_bytes(self.read_array(address)?))
    }

    /// Copies the whole FCRAM.
    pub fn dump_fcram(&self) -> Result<Vec<u8>> {
        let size = self.fcram_size();
        if size == 0 {
            return Err(AzaharError::InvalidState);
        }
        let mut dump = vec![0u8; size];
        for (index, chunk) in dump.chunks_mut(DUMP_CHUNK).enumerate() {
            self.handle.read_fcram(index * DUMP_CHUNK, chunk)?;
        }
        Ok(dump)
    }

    fn read_array<const N: usize>(&self, address: u32) -> Result<[u8; N]> {
        let mut bytes = [0u8; N];
        self.handle.read_memory(address, &mut bytes)?;
        Ok(bytes)
    }
}
