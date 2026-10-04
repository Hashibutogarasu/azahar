// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#pragma once

#include "core/frontend/input.h"

namespace InputManager {

inline std::atomic<int> screen_rotation;

class NDKMotion;

class NDKMotionFactory final : public Input::Factory<Input::MotionDevice> {
public:
    /**
     * Creates a motion device that obtains data from device sensors
     */
    std::unique_ptr<Input::MotionDevice> Create(const Common::ParamPackage& params) override;

    void EnableSensors();
    void DisableSensors();

private:
    NDKMotion* ndk_motion_device;
};

/**
 * Sets the gyroscope's per-axis output multiplier (1.0 = unchanged). vertical_scale scales the
 * pitch axis, horizontal_scale the yaw axis; see NDKMotion::GetStatus() for the exact axis
 * mapping used.
 */
void SetGyroSensitivity(float vertical_scale, float horizontal_scale);

/** Sets whether each gyroscope axis (see SetGyroSensitivity()) should be negated. */
void SetGyroInvert(bool invert_vertical, bool invert_horizontal);

} // namespace InputManager
