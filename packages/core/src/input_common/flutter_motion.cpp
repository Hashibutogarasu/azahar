// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include <memory>
#include <mutex>
#include <tuple>
#include "core/frontend/input.h"
#include "input_common/flutter_motion.h"

namespace InputCommon::FlutterMotion {

namespace {

using Common::Vec3;

std::mutex g_mutex;
Vec3<float> g_accel{};
Vec3<float> g_gyro{};

class FlutterMotionDevice final : public Input::MotionDevice {
public:
    std::tuple<Vec3<float>, Vec3<float>> GetStatus() const override {
        std::lock_guard<std::mutex> guard(g_mutex);
        return {g_accel, g_gyro};
    }
};

class FlutterMotionFactory final : public Input::Factory<Input::MotionDevice> {
public:
    std::unique_ptr<Input::MotionDevice> Create(const Common::ParamPackage&) override {
        return std::make_unique<FlutterMotionDevice>();
    }
};

} // namespace

void Register() {
    Input::RegisterFactory<Input::MotionDevice>(EngineName,
                                                std::make_shared<FlutterMotionFactory>());
}

void Unregister() {
    Input::UnregisterFactory<Input::MotionDevice>(EngineName);
}

void Set(const Vec3<float>& accel, const Vec3<float>& gyro) {
    std::lock_guard<std::mutex> guard(g_mutex);
    g_accel = accel;
    g_gyro = gyro;
}

} // namespace InputCommon::FlutterMotion
