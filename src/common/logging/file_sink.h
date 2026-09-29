// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#pragma once

#include <string>
#include "common/logging/backend.h"

namespace Common::Log {

/**
 * Creates a sink that writes log lines to the file at the given path. The previous run's log is
 * kept next to it with an ".old.txt" suffix. The caller decides where the file lives.
 */
Sink MakeFileSink(const std::string& filename);

} // namespace Common::Log
