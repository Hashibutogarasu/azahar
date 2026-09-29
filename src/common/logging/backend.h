// Copyright 2014 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#pragma once

#include <functional>
#include <string_view>
#include "common/logging/filter.h"

namespace Common::Log {

class Filter;

/**
 * Destination for formatted log lines. The logging backend never decides where log output is
 * stored; the host application installs a sink and owns the log file location and policy.
 */
struct Sink {
    std::function<void(std::string_view line)> write;
    std::function<void()> flush;
};

/// Initializes the logging system. This should be the first thing called in main.
void Initialize();

/**
 * Installs the sink that receives every formatted log line. Lines produced before a sink was
 * installed are buffered and replayed to it in order.
 */
void SetSink(Sink sink);

void Start();

/// Explictily stops the logger thread and flushes the buffers
void Stop();

void DisableLoggingInTests();

/**
 * The global filter will prevent any messages from even being processed if they are filtered.
 */
void SetGlobalFilter(const Filter& filter);

/**
 * Only allow messages that match the specified regex. The regex is matched against the final log
 * text.
 */
bool SetRegexFilter(const std::string& regex);

void SetColorConsoleBackendEnabled(bool enabled);
} // namespace Common::Log
