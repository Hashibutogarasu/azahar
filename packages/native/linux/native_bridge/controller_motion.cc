#include "native_bridge/controller_motion.h"

#include <fcntl.h>
#include <linux/input.h>
#include <poll.h>
#include <sys/ioctl.h>
#include <unistd.h>

#include <array>
#include <atomic>
#include <chrono>
#include <cmath>
#include <cstdio>
#include <mutex>
#include <thread>

namespace ControllerMotion {
namespace {

constexpr double kStandardGravity = 9.80665;
constexpr int kMaxEventNodes = 64;
constexpr int kPollTimeoutMs = 100;
constexpr auto kRescanInterval = std::chrono::seconds(1);

/** The axes and resolutions of the motion sensor node of one controller. */
struct MotionDevice {
  int fd = -1;
  std::array<int, 3> accel_resolution{1, 1, 1};
  std::array<int, 3> gyro_resolution{1, 1, 1};
};

/** One reading of both sensors, in m/s² and rad/s. */
struct Sample {
  std::array<double, 3> accel{};
  std::array<double, 3> gyro{};
};

FlEventChannel* g_channel = nullptr;
std::thread g_worker;
std::atomic<bool> g_running{false};
std::mutex g_sample_mutex;
Sample g_latest;
bool g_pending = false;

bool HasBit(const unsigned long* bits, int bit) {
  constexpr int kBitsPerLong = sizeof(unsigned long) * 8;
  return (bits[bit / kBitsPerLong] >> (bit % kBitsPerLong)) & 1UL;
}

int ResolutionOf(int fd, int axis) {
  input_absinfo info{};
  if (ioctl(fd, EVIOCGABS(axis), &info) < 0 || info.resolution <= 0) {
    return 1;
  }
  return info.resolution;
}

/** Opens the first event node that is the motion sensor of a controller, or returns fd -1. */
MotionDevice FindMotionDevice() {
  for (int i = 0; i < kMaxEventNodes; ++i) {
    char path[32];
    std::snprintf(path, sizeof(path), "/dev/input/event%d", i);
    const int fd = open(path, O_RDONLY | O_NONBLOCK | O_CLOEXEC);
    if (fd < 0) {
      continue;
    }
    unsigned long props[(INPUT_PROP_CNT + sizeof(unsigned long) * 8 - 1) /
                        (sizeof(unsigned long) * 8)]{};
    unsigned long abs_bits[(ABS_CNT + sizeof(unsigned long) * 8 - 1) /
                           (sizeof(unsigned long) * 8)]{};
    const bool is_motion =
        ioctl(fd, EVIOCGPROP(sizeof(props)), props) >= 0 &&
        HasBit(props, INPUT_PROP_ACCELEROMETER) &&
        ioctl(fd, EVIOCGBIT(EV_ABS, sizeof(abs_bits)), abs_bits) >= 0 &&
        HasBit(abs_bits, ABS_X) && HasBit(abs_bits, ABS_RX);
    if (!is_motion) {
      close(fd);
      continue;
    }
    MotionDevice device;
    device.fd = fd;
    device.accel_resolution = {ResolutionOf(fd, ABS_X), ResolutionOf(fd, ABS_Y),
                               ResolutionOf(fd, ABS_Z)};
    device.gyro_resolution = {ResolutionOf(fd, ABS_RX), ResolutionOf(fd, ABS_RY),
                              ResolutionOf(fd, ABS_RZ)};
    return device;
  }
  return {};
}

gboolean SendLatestSample(gpointer) {
  Sample sample;
  {
    std::lock_guard lock(g_sample_mutex);
    sample = g_latest;
    g_pending = false;
  }
  if (g_channel == nullptr) {
    return G_SOURCE_REMOVE;
  }
  g_autoptr(FlValue) accel = fl_value_new_list();
  g_autoptr(FlValue) gyro = fl_value_new_list();
  for (int i = 0; i < 3; ++i) {
    fl_value_append_take(accel, fl_value_new_float(sample.accel[i]));
    fl_value_append_take(gyro, fl_value_new_float(sample.gyro[i]));
  }
  g_autoptr(FlValue) map = fl_value_new_map();
  fl_value_set_string(map, "accel", accel);
  fl_value_set_string(map, "gyro", gyro);
  fl_event_channel_send(g_channel, map, nullptr, nullptr);
  return G_SOURCE_REMOVE;
}

void Publish(const MotionDevice& device, const std::array<int, 3>& accel,
             const std::array<int, 3>& gyro) {
  Sample sample;
  for (int i = 0; i < 3; ++i) {
    sample.accel[i] =
        static_cast<double>(accel[i]) / device.accel_resolution[i] * kStandardGravity;
    sample.gyro[i] = static_cast<double>(gyro[i]) / device.gyro_resolution[i] * M_PI / 180.0;
  }
  std::lock_guard lock(g_sample_mutex);
  g_latest = sample;
  if (!g_pending) {
    g_pending = true;
    g_idle_add(SendLatestSample, nullptr);
  }
}

/** Reads the motion sensor of a controller, looking for one again whenever it is gone. */
void Run() {
  MotionDevice device;
  std::array<int, 3> accel{};
  std::array<int, 3> gyro{};
  while (g_running) {
    if (device.fd < 0) {
      device = FindMotionDevice();
      if (device.fd < 0) {
        for (auto waited = std::chrono::milliseconds(0);
             g_running && waited < kRescanInterval;
             waited += std::chrono::milliseconds(kPollTimeoutMs)) {
          std::this_thread::sleep_for(std::chrono::milliseconds(kPollTimeoutMs));
        }
        continue;
      }
    }
    pollfd poll_fd{device.fd, POLLIN, 0};
    const int ready = poll(&poll_fd, 1, kPollTimeoutMs);
    if (ready <= 0) {
      continue;
    }
    if (poll_fd.revents & (POLLERR | POLLHUP | POLLNVAL)) {
      close(device.fd);
      device = {};
      continue;
    }
    input_event event{};
    while (read(device.fd, &event, sizeof(event)) == sizeof(event)) {
      if (event.type == EV_ABS) {
        switch (event.code) {
        case ABS_X:
        case ABS_Y:
        case ABS_Z:
          accel[event.code - ABS_X] = event.value;
          break;
        case ABS_RX:
        case ABS_RY:
        case ABS_RZ:
          gyro[event.code - ABS_RX] = event.value;
          break;
        default:
          break;
        }
      } else if (event.type == EV_SYN && event.code == SYN_REPORT) {
        Publish(device, accel, gyro);
      }
    }
  }
  if (device.fd >= 0) {
    close(device.fd);
  }
}

}  // namespace

void SetEventChannel(FlEventChannel* channel) {
  g_channel = channel;
  if (channel != nullptr && !g_running) {
    g_running = true;
    g_worker = std::thread(Run);
  } else if (channel == nullptr && g_running) {
    g_running = false;
    if (g_worker.joinable()) {
      g_worker.join();
    }
  }
}

}  // namespace ControllerMotion
