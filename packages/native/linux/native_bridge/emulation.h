#ifndef RUNNER_NATIVE_BRIDGE_EMULATION_H_
#define RUNNER_NATIVE_BRIDGE_EMULATION_H_

#include <cstddef>
#include <cstdint>
#include <functional>
#include <memory>
#include <string>

#include <flutter_linux/flutter_linux.h>

namespace Emulation {

void SetConsoleLogEnabled(bool enabled);
void SetLogLinesChannel(FlEventChannel* channel);

/**
 * Registers the texture registrar that sessions create their screen textures with.
 */
void SetTextureRegistrar(FlTextureRegistrar* registrar);

/**
 * Receivers of everything a session reports from its own threads.
 */
struct SessionCallbacks {
  std::function<void(int32_t stage, uint64_t progress, uint64_t max)> on_shader_progress;
  std::function<void(int64_t texture_id, bool secondary)> on_texture;
  std::function<void(const std::string& message)> on_error;
  std::function<void(const int16_t* frames, std::size_t frame_count)> on_audio;
};

struct SessionOptions {
  int primary_width = 400;
  int primary_height = 240;
  int secondary_width = 320;
  int secondary_height = 240;
  bool dual_screen = false;
};

/**
 * One emulation session.
 *
 * The session owns every resource it creates: the emulation and present threads, the windows,
 * the Flutter textures, the GPU and core state, and the input and network subsystems. The
 * destructor stops the emulation, joins the threads and releases all of them, so a new session
 * can be created in the same process afterwards.
 */
class Session {
 public:
  struct Impl;

  Session(std::string game_path, SessionOptions options, SessionCallbacks callbacks);
  ~Session();

  Session(const Session&) = delete;
  Session& operator=(const Session&) = delete;

  /**
   * Creates the textures and starts the emulation. Returns false when the session cannot start.
   */
  bool Start();
  void Pause();
  void Resume();
  void AdvanceFrame();
  void PauseRendering();
  void ResumeRendering();
  bool IsPaused() const;

  /**
   * Size in bytes of the FCRAM of the loaded system, or 0 while nothing is loaded.
   */
  std::size_t FcramSize() const;

  /**
   * Copies guest memory. Returns false when any part of the range is not mapped.
   */
  bool ReadMemory(uint32_t address, uint8_t* out, std::size_t length);

  /**
   * Copies FCRAM. Returns false when the range exceeds the FCRAM size.
   */
  bool ReadFcram(std::size_t offset, uint8_t* out, std::size_t length);

  bool OnTouchEvent(double x, double y, bool pressed);
  void OnTouchMoved(double x, double y);

 private:
  std::unique_ptr<Impl> impl_;
};

/**
 * Whether a session currently owns the emulation.
 */
bool IsSessionActive();

void AdvanceFrame();
void PauseRendering();
void ResumeRendering();
bool OnTouchEvent(double x, double y, bool pressed);
void OnTouchMoved(double x, double y);
bool SwapScreens();

}  // namespace Emulation

#endif  // RUNNER_NATIVE_BRIDGE_EMULATION_H_
