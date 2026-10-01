// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include <array>
#include <chrono>
#include <vector>
#include "audio_core/audio_types.h"
#include "audio_core/external_sink.h"

namespace AudioCore {

namespace {

constexpr std::size_t frames_per_period = 256;

std::mutex handler_mutex;
ExternalAudioHandler external_handler;

} // Anonymous namespace

void SetExternalAudioHandler(ExternalAudioHandler handler) {
    std::lock_guard lock{handler_mutex};
    external_handler = std::move(handler);
}

ExternalSink::ExternalSink(std::string_view) {
    pacing_thread = std::thread([this] { Run(); });
}

ExternalSink::~ExternalSink() {
    stop_requested = true;
    if (pacing_thread.joinable()) {
        pacing_thread.join();
    }
}

unsigned int ExternalSink::GetNativeSampleRate() const {
    return native_sample_rate;
}

void ExternalSink::SetCallback(std::function<void(s16*, std::size_t)> cb) {
    std::lock_guard lock{callback_mutex};
    callback = std::move(cb);
}

void ExternalSink::Run() {
    using Clock = std::chrono::steady_clock;
    const auto period = std::chrono::nanoseconds(std::chrono::seconds(1)) * frames_per_period /
                        native_sample_rate;
    std::vector<s16> buffer(frames_per_period * 2);
    auto next_period = Clock::now();

    while (!stop_requested) {
        next_period += period;
        {
            std::lock_guard lock{callback_mutex};
            if (callback) {
                callback(buffer.data(), frames_per_period);
                std::lock_guard handler_lock{handler_mutex};
                if (external_handler) {
                    external_handler(buffer.data(), frames_per_period);
                }
            }
        }
        std::this_thread::sleep_until(next_period);
    }
}

} // namespace AudioCore
