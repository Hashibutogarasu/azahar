#include "gamepad.h"

#include <algorithm>
#include <atomic>
#include <cstring>
#include <list>
#include <memory>
#include <mutex>
#include <string>
#include <tuple>

#include "common/param_package.h"
#include "common/settings.h"
#include "common/vector_math.h"
#include "core/frontend/input.h"
#include "input_common/flutter_motion.h"

namespace Gamepad {

namespace {

constexpr int kCodeA = 700;
constexpr int kCodeB = 701;
constexpr int kCodeX = 702;
constexpr int kCodeY = 703;
constexpr int kCodeStart = 704;
constexpr int kCodeSelect = 705;
constexpr int kCodeHome = 706;
constexpr int kCodeZl = 707;
constexpr int kCodeZr = 708;
constexpr int kCodeUp = 709;
constexpr int kCodeDown = 710;
constexpr int kCodeLeft = 711;
constexpr int kCodeRight = 712;
constexpr int kCodeCirclePad = 713;
constexpr int kCodeCStick = 718;
constexpr int kCodeL = 773;
constexpr int kCodeR = 774;

FlEventChannel* g_event_channel = nullptr;

class ButtonList;

class KeyButton final : public Input::ButtonDevice {
public:
    explicit KeyButton(std::shared_ptr<ButtonList> list) : list_(std::move(list)) {}
    ~KeyButton() override;

    bool GetStatus() const override {
        return status_.load();
    }

    std::atomic<bool> status_{false};

private:
    std::shared_ptr<ButtonList> list_;
};

class ButtonList {
public:
    void Add(int code, KeyButton* button) {
        std::lock_guard<std::mutex> guard(mutex_);
        entries_.push_back({code, button});
    }

    void Remove(const KeyButton* button) {
        std::lock_guard<std::mutex> guard(mutex_);
        entries_.remove_if([button](const Entry& entry) { return entry.button == button; });
    }

    void Change(int code, bool pressed) {
        std::lock_guard<std::mutex> guard(mutex_);
        for (const Entry& entry : entries_) {
            if (entry.code == code) {
                entry.button->status_.store(pressed);
            }
        }
    }

private:
    struct Entry {
        int code;
        KeyButton* button;
    };

    std::mutex mutex_;
    std::list<Entry> entries_;
};

KeyButton::~KeyButton() {
    list_->Remove(this);
}

class AnalogList;

class Joystick final : public Input::AnalogDevice {
public:
    explicit Joystick(std::shared_ptr<AnalogList> list) : list_(std::move(list)) {}
    ~Joystick() override;

    std::tuple<float, float> GetStatus() const override {
        return std::make_tuple(x_.load(), y_.load());
    }

    std::atomic<float> x_{0.0f};
    std::atomic<float> y_{0.0f};

private:
    std::shared_ptr<AnalogList> list_;
};

class AnalogList {
public:
    void Add(int code, Joystick* joystick) {
        std::lock_guard<std::mutex> guard(mutex_);
        entries_.push_back({code, joystick});
    }

    void Remove(const Joystick* joystick) {
        std::lock_guard<std::mutex> guard(mutex_);
        entries_.remove_if([joystick](const Entry& entry) { return entry.joystick == joystick; });
    }

    void Move(int code, float x, float y) {
        std::lock_guard<std::mutex> guard(mutex_);
        for (const Entry& entry : entries_) {
            if (entry.code == code) {
                entry.joystick->x_.store(x);
                entry.joystick->y_.store(y);
            }
        }
    }

private:
    struct Entry {
        int code;
        Joystick* joystick;
    };

    std::mutex mutex_;
    std::list<Entry> entries_;
};

Joystick::~Joystick() {
    list_->Remove(this);
}

class ButtonFactory final : public Input::Factory<Input::ButtonDevice> {
public:
    std::unique_ptr<Input::ButtonDevice> Create(const Common::ParamPackage& params) override {
        auto button = std::make_unique<KeyButton>(list);
        list->Add(params.Get("code", 0), button.get());
        return button;
    }

    std::shared_ptr<ButtonList> list = std::make_shared<ButtonList>();
};

class AnalogFactory final : public Input::Factory<Input::AnalogDevice> {
public:
    std::unique_ptr<Input::AnalogDevice> Create(const Common::ParamPackage& params) override {
        auto joystick = std::make_unique<Joystick>(list);
        list->Add(params.Get("code", 0), joystick.get());
        return joystick;
    }

    std::shared_ptr<AnalogList> list = std::make_shared<AnalogList>();
};

std::shared_ptr<ButtonFactory> g_buttons;
std::shared_ptr<AnalogFactory> g_analogs;

std::string ParamFor(int code) {
    return Common::ParamPackage{{"engine", "gamepad"}, {"code", std::to_string(code)}}.Serialize();
}

void SetIfEmpty(std::string& target, int code) {
    if (target.empty()) {
        target = ParamFor(code);
    }
}

double NumberAt(FlValue* list, size_t index) {
    FlValue* value = fl_value_get_list_value(list, index);
    return fl_value_get_type(value) == FL_VALUE_TYPE_INT
               ? static_cast<double>(fl_value_get_int(value))
               : fl_value_get_float(value);
}

Common::Vec3<float> Vec3At(FlValue* list) {
    return Common::Vec3<float>{static_cast<float>(NumberAt(list, 0)),
                               static_cast<float>(NumberAt(list, 1)),
                               static_cast<float>(NumberAt(list, 2))};
}

void Report(FlValue* args) {
    if (g_event_channel != nullptr) {
        fl_event_channel_send(g_event_channel, args, nullptr, nullptr);
    }
}

}  // namespace

void EnsureInputProfileInitialized() {
    auto& profile = Settings::values.current_input_profile;
    SetIfEmpty(profile.buttons[Settings::NativeButton::A], kCodeA);
    SetIfEmpty(profile.buttons[Settings::NativeButton::B], kCodeB);
    SetIfEmpty(profile.buttons[Settings::NativeButton::X], kCodeX);
    SetIfEmpty(profile.buttons[Settings::NativeButton::Y], kCodeY);
    SetIfEmpty(profile.buttons[Settings::NativeButton::Up], kCodeUp);
    SetIfEmpty(profile.buttons[Settings::NativeButton::Down], kCodeDown);
    SetIfEmpty(profile.buttons[Settings::NativeButton::Left], kCodeLeft);
    SetIfEmpty(profile.buttons[Settings::NativeButton::Right], kCodeRight);
    SetIfEmpty(profile.buttons[Settings::NativeButton::L], kCodeL);
    SetIfEmpty(profile.buttons[Settings::NativeButton::R], kCodeR);
    SetIfEmpty(profile.buttons[Settings::NativeButton::Start], kCodeStart);
    SetIfEmpty(profile.buttons[Settings::NativeButton::Select], kCodeSelect);
    SetIfEmpty(profile.buttons[Settings::NativeButton::ZL], kCodeZl);
    SetIfEmpty(profile.buttons[Settings::NativeButton::ZR], kCodeZr);
    SetIfEmpty(profile.buttons[Settings::NativeButton::Home], kCodeHome);
    SetIfEmpty(profile.analogs[Settings::NativeAnalog::CirclePad], kCodeCirclePad);
    SetIfEmpty(profile.analogs[Settings::NativeAnalog::CStick], kCodeCStick);
    profile.motion_device = std::string("engine:") + InputCommon::FlutterMotion::EngineName;
}

void Register() {
    g_buttons = std::make_shared<ButtonFactory>();
    g_analogs = std::make_shared<AnalogFactory>();
    Input::RegisterFactory<Input::ButtonDevice>("gamepad", g_buttons);
    Input::RegisterFactory<Input::AnalogDevice>("gamepad", g_analogs);
    InputCommon::FlutterMotion::Register();
}

void SetEventChannel(FlEventChannel* channel) {
    g_event_channel = channel;
}

bool Send(FlValue* args) {
    if (args == nullptr || fl_value_get_type(args) != FL_VALUE_TYPE_MAP) {
        return false;
    }
    FlValue* kind_value = fl_value_lookup_string(args, "kind");
    if (kind_value == nullptr || fl_value_get_type(kind_value) != FL_VALUE_TYPE_STRING) {
        return false;
    }
    const char* kind = fl_value_get_string(kind_value);

    if (std::strcmp(kind, "button") == 0) {
        FlValue* code = fl_value_lookup_string(args, "code");
        FlValue* pressed = fl_value_lookup_string(args, "pressed");
        if (code == nullptr || pressed == nullptr || !g_buttons) {
            return false;
        }
        g_buttons->list->Change(static_cast<int>(fl_value_get_int(code)),
                                fl_value_get_bool(pressed));
    } else if (std::strcmp(kind, "axis") == 0) {
        FlValue* code = fl_value_lookup_string(args, "code");
        FlValue* x = fl_value_lookup_string(args, "x");
        FlValue* y = fl_value_lookup_string(args, "y");
        if (code == nullptr || x == nullptr || y == nullptr || !g_analogs) {
            return false;
        }
        g_analogs->list->Move(static_cast<int>(fl_value_get_int(code)),
                              std::clamp(static_cast<float>(fl_value_get_float(x)), -1.0f, 1.0f),
                              std::clamp(static_cast<float>(fl_value_get_float(y)), -1.0f, 1.0f));
    } else if (std::strcmp(kind, "motion") == 0) {
        FlValue* accel = fl_value_lookup_string(args, "accel");
        FlValue* gyro = fl_value_lookup_string(args, "gyro");
        if (accel == nullptr || gyro == nullptr) {
            return false;
        }
        InputCommon::FlutterMotion::Set(Vec3At(accel), Vec3At(gyro));
    } else {
        return false;
    }
    Report(args);
    return true;
}

}  // namespace Gamepad
