// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#pragma once

#include "common/vector_math.h"

namespace InputCommon::FlutterMotion {

/// The name of the motion engine, to be used as `engine:flutter_motion` in an input profile.
constexpr const char* EngineName = "flutter_motion";

/**
 * Registers the "flutter_motion" motion device factory. Its devices report the values last given
 * to Set, so the frontend supplies the motion sensor samples instead of the core reading them.
 */
void Register();

/// Unregisters the factory registered by Register.
void Unregister();

/**
 * Stores the latest motion sample.
 * @param accel acceleration in g, with the axes of the 3DS
 * @param gyro angular velocity in degrees per second, with the axes of the 3DS
 */
void Set(const Common::Vec3<float>& accel, const Common::Vec3<float>& gyro);

} // namespace InputCommon::FlutterMotion
