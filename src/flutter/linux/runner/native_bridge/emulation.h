#ifndef RUNNER_NATIVE_BRIDGE_EMULATION_H_
#define RUNNER_NATIVE_BRIDGE_EMULATION_H_

#include <cstdint>
#include <string>

#include <flutter_linux/flutter_linux.h>

namespace Emulation {

void SetConsoleLogEnabled(bool enabled);
int64_t CreateTexture(FlTextureRegistrar* registrar, int width, int height, bool secondary);
void SetShaderProgressChannel(FlEventChannel* channel);
void StartEmulation(const std::string& path);
bool IsRunning();
bool IsSessionActive();
void PauseEmulation();
void ResumeEmulation();
void PauseRendering();
void ResumeRendering();
void StopEmulation();
void StopPresentingAndWait();
void StopAndWait();
bool OnTouchEvent(double x, double y, bool pressed);
void OnTouchMoved(double x, double y);
bool SwapScreens();

}  // namespace Emulation

#endif  // RUNNER_NATIVE_BRIDGE_EMULATION_H_
