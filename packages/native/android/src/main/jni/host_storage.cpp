// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include <azahar_storage.h>
#include "common/storage.h"

namespace {

/**
 * Registers the storage of the Rust crate while the library loads. It lives in a file of its own
 * because only the library of the application contains the crate, and the library of a session
 * receives the table through `AzaharHostState` instead.
 */
const bool g_registered = [] {
    Common::Storage::Register(azahar_storage_api());
    return true;
}();

} // Anonymous namespace
