#pragma once

#include <flutter_linux/flutter_linux.h>

namespace ControllerMotion {

/**
 * Sets or clears the channel the motion sensors of a connected game controller are reported to,
 * as maps with "accel" in m/s² and "gyro" in rad/s, each a list of three numbers. The sensors are
 * only read while a channel is set. Called on the main thread.
 */
void SetEventChannel(FlEventChannel* channel);

}  // namespace ControllerMotion
