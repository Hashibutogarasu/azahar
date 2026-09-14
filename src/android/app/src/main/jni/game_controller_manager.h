// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#pragma once

#include <jni.h>

namespace GameControllerManager {

/**
 * Initializes the Android Game Controller Library (Paddleboat) so that physical controllers
 * (PS4, Joy-Con, Xbox, etc.) can be auto-detected and mapped to standardized buttons/axes,
 * instead of relying on the user's manual per-button bindings.
 */
void Init(JNIEnv* env, jobject context);

/**
 * Releases the Game Controller Library. Safe to call even if Init() was never called.
 */
void Shutdown(JNIEnv* env);

/**
 * Merges virtual (SetVirtualButton()/SetVirtualStick()) and, if read_physical_controllers,
 * physical controller state into InputManager. Leaves a button/stick untouched when neither
 * source has anything to report, so the separate manual key/axis mapping path
 * (Java_..._onGamePadEvent/onGamePadMoveEvent) keeps working when physical controllers aren't
 * read here. Safe to call regardless of Init() state or controller input mode; call once per
 * frame. invert_left_stick_y negates a physical left stick's Y axis; virtual input is unaffected.
 */
void Update(JNIEnv* env, bool invert_left_stick_y, bool read_physical_controllers);

/** Records a virtual (touch overlay) button's pressed state; merged into InputManager by Update(). */
void SetVirtualButton(int n3ds_button_id, bool pressed);

/** Records a virtual (touch overlay) stick's x/y position; merged into InputManager by Update(). */
void SetVirtualStick(int n3ds_analog_id, float x, float y);

/**
 * Sets whether a physical controller's gyroscope should be used in place of the Android device's
 * own gyroscope, when the currently connected controller reports gyroscope support. Safe to call
 * whether or not Init() has been called.
 */
void SetGyroPreferExternalController(bool prefer);

/**
 * Fills x/y/z with the latest gyroscope sample from a physical controller, as reported by
 * Paddleboat (raw units, matching Android's ASENSOR_TYPE_GYROSCOPE rad/s convention; the caller
 * is responsible for any unit/axis conversion), and returns true, if
 * SetGyroPreferExternalController(true) is in effect, Paddleboat is initialized, and a
 * gyroscope-capable controller has reported at least one sample. Returns false (leaving x/y/z
 * untouched) otherwise, so the caller should fall back to the device's own gyroscope.
 */
bool TryGetControllerGyro(float* x, float* y, float* z);

/**
 * Forwards a Java KeyEvent for controller processing. Only meaningful on API level 31+, where
 * the NDK can translate a Java input event into an AInputEvent; returns false otherwise so the
 * caller can fall back to manual key mapping.
 */
bool ProcessKeyEvent(JNIEnv* env, jobject key_event);

/**
 * Forwards a Java MotionEvent for controller processing. Same API level 31+ caveat as
 * ProcessKeyEvent().
 */
bool ProcessMotionEvent(JNIEnv* env, jobject motion_event);

} // namespace GameControllerManager
