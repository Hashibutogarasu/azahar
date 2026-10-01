#include "azahar_session.h"

#include <memory>
#include <string>

#include "emulation.h"

struct AzaharSession {
  AzaharSessionCallbacks callbacks;
  std::unique_ptr<Emulation::Session> session;
};

namespace {

Emulation::SessionCallbacks MakeCallbacks(const AzaharSessionCallbacks& raw) {
  Emulation::SessionCallbacks callbacks;
  if (raw.on_shader_progress != nullptr) {
    callbacks.on_shader_progress = [raw](int32_t stage, uint64_t progress, uint64_t max) {
      raw.on_shader_progress(raw.user, stage, progress, max);
    };
  }
  if (raw.on_texture != nullptr) {
    callbacks.on_texture = [raw](int64_t texture_id, bool secondary) {
      raw.on_texture(raw.user, texture_id, secondary ? 1 : 0);
    };
  }
  if (raw.on_error != nullptr) {
    callbacks.on_error = [raw](const std::string& message) {
      raw.on_error(raw.user, message.c_str());
    };
  }
  if (raw.on_audio != nullptr) {
    callbacks.on_audio = [raw](const int16_t* frames, std::size_t frame_count) {
      raw.on_audio(raw.user, frames, frame_count);
    };
  }
  return callbacks;
}

}  // namespace

extern "C" {

AzaharSession* azahar_session_create(const char* game_path, const AzaharSessionOptions* options,
                                     const AzaharSessionCallbacks* callbacks) {
  if (game_path == nullptr || options == nullptr || callbacks == nullptr) {
    return nullptr;
  }
  auto wrapper = std::make_unique<AzaharSession>();
  wrapper->callbacks = *callbacks;

  Emulation::SessionOptions session_options;
  session_options.primary_width = options->primary_width;
  session_options.primary_height = options->primary_height;
  session_options.secondary_width = options->secondary_width;
  session_options.secondary_height = options->secondary_height;
  session_options.dual_screen = options->dual_screen != 0;

  wrapper->session = std::make_unique<Emulation::Session>(
      game_path, session_options, MakeCallbacks(wrapper->callbacks));
  return wrapper.release();
}

int32_t azahar_session_start(AzaharSession* session) {
  if (session == nullptr) {
    return AZAHAR_STATUS_INVALID_ARGUMENT;
  }
  return session->session->Start() ? AZAHAR_STATUS_OK : AZAHAR_STATUS_LOAD_FAILED;
}

int32_t azahar_session_pause(AzaharSession* session) {
  if (session == nullptr) {
    return AZAHAR_STATUS_INVALID_ARGUMENT;
  }
  session->session->Pause();
  return AZAHAR_STATUS_OK;
}

int32_t azahar_session_resume(AzaharSession* session) {
  if (session == nullptr) {
    return AZAHAR_STATUS_INVALID_ARGUMENT;
  }
  session->session->Resume();
  return AZAHAR_STATUS_OK;
}

size_t azahar_session_fcram_size(const AzaharSession* session) {
  return session == nullptr ? 0 : session->session->FcramSize();
}

int32_t azahar_session_read_memory(AzaharSession* session, uint32_t address, uint8_t* out,
                                   size_t len) {
  if (session == nullptr || out == nullptr) {
    return AZAHAR_STATUS_INVALID_ARGUMENT;
  }
  return session->session->ReadMemory(address, out, len) ? AZAHAR_STATUS_OK
                                                         : AZAHAR_STATUS_INVALID_ADDRESS;
}

int32_t azahar_session_read_fcram(AzaharSession* session, size_t offset, uint8_t* out, size_t len) {
  if (session == nullptr || out == nullptr) {
    return AZAHAR_STATUS_INVALID_ARGUMENT;
  }
  return session->session->ReadFcram(offset, out, len) ? AZAHAR_STATUS_OK
                                                       : AZAHAR_STATUS_INVALID_ADDRESS;
}

void azahar_session_destroy(AzaharSession* session) {
  delete session;
}

}
