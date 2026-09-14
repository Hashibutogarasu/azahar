// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include <fmt/format.h>
#include "common/file_util.h"
#include "common/settings.h"
#include "core/core.h"
#include "core/core_timing.h"
#include "core/memory.h"
#include "core/memory_tools.h"

namespace Core {

namespace {
constexpr u64 memory_recorder_interval_ticks = BASE_CLOCK_RATE_ARM11 / 60;
}

std::vector<u8> DumpFCRAM(System& system) {
    const std::size_t fcram_size = Settings::values.is_new_3ds.GetValue()
                                        ? Memory::FCRAM_N3DS_SIZE
                                        : Memory::FCRAM_SIZE;
    const u8* fcram = system.Memory().GetFCRAMPointer(0);
    return std::vector<u8>(fcram, fcram + fcram_size);
}

MemoryRecorder::MemoryRecorder(System& system_) : system{system_} {}

MemoryRecorder::~MemoryRecorder() {
    if (recording) {
        StopRecording();
    }
}

bool MemoryRecorder::IsRecording() const {
    return recording;
}

void MemoryRecorder::StartRecording(const std::string& output_dir_) {
    if (recording) {
        return;
    }

    output_dir = output_dir_;
    frame_count = 0;
    stop_writer = false;

    writer_thread = std::thread(&MemoryRecorder::WriterThreadFunc, this);

    event = system.CoreTiming().RegisterEvent(
        "MemoryRecorder::run_event",
        [this](u64 thread_id, s64 cycle_late) { RunCallback(thread_id, cycle_late); });
    system.CoreTiming().ScheduleEvent(memory_recorder_interval_ticks, event);

    recording = true;
}

u32 MemoryRecorder::StopRecording() {
    if (!recording) {
        return frame_count;
    }

    recording = false;
    if (system.IsPoweredOn()) {
        system.CoreTiming().UnscheduleEvent(event, 0);
    }

    {
        std::scoped_lock lock{queue_mutex};
        stop_writer = true;
    }
    queue_cv.notify_all();
    if (writer_thread.joinable()) {
        writer_thread.join();
    }

    return frame_count;
}

void MemoryRecorder::RunCallback([[maybe_unused]] std::uintptr_t user_data, s64 cycles_late) {
    if (!recording) {
        return;
    }

    {
        std::scoped_lock lock{queue_mutex};
        pending_frames.push(DumpFCRAM(system));
    }
    queue_cv.notify_one();

    system.CoreTiming().ScheduleEvent(memory_recorder_interval_ticks - cycles_late, event);
}

void MemoryRecorder::WriterThreadFunc() {
    while (true) {
        std::vector<u8> frame;
        {
            std::unique_lock lock{queue_mutex};
            queue_cv.wait(lock, [this] { return !pending_frames.empty() || stop_writer; });
            if (pending_frames.empty() && stop_writer) {
                break;
            }
            frame = std::move(pending_frames.front());
            pending_frames.pop();
        }

        const std::string filepath = fmt::format("{}/frame_{:06d}.bin", output_dir, frame_count);
        FileUtil::IOFile file(filepath, "wb");
        file.WriteBytes(frame.data(), frame.size());
        ++frame_count;
    }
}

} // namespace Core
