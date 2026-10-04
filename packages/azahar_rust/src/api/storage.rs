use crate::error::AzaharError;
use crate::storage;

/// Prepares the user directory of a profile before it is switched to, so a new profile can be
/// started without the core failing on missing folders.
pub fn initialize_storage(location: String) -> Result<(), AzaharError> {
    storage::initialize(&location)
}
