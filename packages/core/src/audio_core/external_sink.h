// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#pragma once

#include <atomic>
#include <cstddef>
#include <functional>
#include <memory>
#include <mutex>
#include <string_view>
#include <thread>
#include "audio_core/sink.h"
#include "common/common_types.h"

namespace AudioCore {

/**
 * Receiver of the audio frames produced by an ExternalSink.
 * The frames are interleaved signed PCM16 stereo sampled at the native DSP rate.
 */
using ExternalAudioHandler = std::function<void(const s16* frames, std::size_t frame_count)>;

/**
 * Installs the handler that every ExternalSink forwards its audio to.
 * Passing an empty handler detaches the current one. The call does not return while a handler
 * invocation is in flight, so after it returns the previous handler is never called again.
 */
void SetExternalAudioHandler(ExternalAudioHandler handler);

/**
 * A sink that does not own an audio device. A pacing thread pulls frames from the DSP at the
 * native sample rate and pushes them to the installed ExternalAudioHandler, which lets the
 * embedding application own the audio output and its lifetime.
 */
class ExternalSink final : public Sink {
public:
    explicit ExternalSink(std::string_view device_id);
    ~ExternalSink() override;

    unsigned int GetNativeSampleRate() const override;

    void SetCallback(std::function<void(s16*, std::size_t)> cb) override;

private:
    void Run();

    std::mutex callback_mutex;
    std::function<void(s16*, std::size_t)> callback;
    std::atomic<bool> stop_requested{false};
    std::thread pacing_thread;
};

} // namespace AudioCore
