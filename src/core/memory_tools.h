// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#pragma once

#include <atomic>
#include <condition_variable>
#include <mutex>
#include <queue>
#include <string>
#include <thread>
#include <vector>
#include "common/common_types.h"

namespace Core {
class System;
struct TimingEventType;

/**
 * Copies the entire FCRAM contents of the currently running session into a byte buffer.
 */
std::vector<u8> DumpFCRAM(System& system);

/**
 * Captures one FCRAM snapshot per emulated frame while a recording session is active, and
 * writes each snapshot to a sequentially numbered binary file in a caller-provided directory.
 * Snapshots are captured synchronously on the emulation thread and handed off to a dedicated
 * writer thread so that disk I/O does not stall emulation.
 */
class MemoryRecorder {
public:
    explicit MemoryRecorder(System& system);
    ~MemoryRecorder();

    /// Starts capturing FCRAM snapshots into sequentially numbered files under output_dir.
    void StartRecording(const std::string& output_dir);

    /// Stops capturing snapshots and returns the number of frames that were written.
    u32 StopRecording();

    /// Whether a recording session is currently active.
    bool IsRecording() const;

private:
    void RunCallback(std::uintptr_t user_data, s64 cycles_late);
    void WriterThreadFunc();

    System& system;
    TimingEventType* event = nullptr;
    std::atomic_bool recording{false};

    std::string output_dir;
    u32 frame_count = 0;

    std::thread writer_thread;
    std::mutex queue_mutex;
    std::condition_variable queue_cv;
    std::queue<std::vector<u8>> pending_frames;
    bool stop_writer = false;
};

} // namespace Core
