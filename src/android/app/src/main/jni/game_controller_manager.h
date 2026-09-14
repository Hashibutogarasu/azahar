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
 * Polls every connected controller once and forwards standardized button/axis state into
 * InputManager, mirroring what the manual key/axis bindings normally feed in. Must be called
 * once per frame while auto-detect controller mode is active. When invert_left_stick_y is true,
 * the left stick's (circle pad) Y axis is negated before being forwarded.
 */
void Update(JNIEnv* env, bool invert_left_stick_y);

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
