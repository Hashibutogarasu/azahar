#pragma once

#include <flutter_linux/flutter_linux.h>

namespace Gamepad {

/// Binds the 3DS buttons and analog sticks of the input profile to the "gamepad" engine, if the
/// profile has no binding yet. It has to run before the emulation loads the input devices.
void EnsureInputProfileInitialized();

/// Registers the "gamepad" button and analog device factories and the "flutter_motion" motion
/// device factory. It has to run once, after InputCommon::Init().
void Register();

/// Sets or clears the channel every handled input is reported to. Called on the main thread.
void SetEventChannel(FlEventChannel* channel);

/**
 * Gives one input to the core and reports it on the event channel.
 * @param args a map with "kind" set to "button" ("code", "pressed"), "axis" ("code", "x", "y") or
 *     "motion" ("accel" and "gyro", each a list of three numbers)
 * @return whether [args] described a known kind of input
 */
bool Send(FlValue* args);

}  // namespace Gamepad
