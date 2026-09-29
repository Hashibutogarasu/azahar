#include "wifi.h"

#include <cstdio>
#include <mutex>

#include "core/hle/service/ac/ac.h"

namespace Wifi {

namespace {

std::mutex& AccessPointsMutex() {
  static std::mutex mutex;
  return mutex;
}

std::optional<std::vector<Service::AC::HostApInfo>>& StoredAccessPoints() {
  static std::optional<std::vector<Service::AC::HostApInfo>> access_points;
  return access_points;
}

void EnsureScannerRegistered() {
  static const bool registered = [] {
    Service::AC::RegisterHostWifiScanner([] {
      std::lock_guard lock(AccessPointsMutex());
      return StoredAccessPoints();
    });
    return true;
  }();
  (void)registered;
}

Service::AC::HostApInfo ToHostApInfo(const AccessPoint& access_point) {
  Service::AC::HostApInfo info;
  info.ssid = access_point.ssid;
  unsigned int bssid[6]{};
  std::sscanf(access_point.bssid.c_str(), "%2x:%2x:%2x:%2x:%2x:%2x", &bssid[0], &bssid[1],
              &bssid[2], &bssid[3], &bssid[4], &bssid[5]);
  for (std::size_t i = 0; i < info.bssid.size(); ++i) {
    info.bssid[i] = static_cast<uint8_t>(bssid[i]);
  }
  info.rssi = static_cast<int16_t>(access_point.level);
  info.channel = static_cast<uint8_t>(access_point.channel);
  info.security = Service::AC::ApSecurity::Open;
  return info;
}

}  // namespace

void SetVirtualAccessPoints(std::optional<std::vector<AccessPoint>> access_points) {
  EnsureScannerRegistered();

  std::optional<std::vector<Service::AC::HostApInfo>> converted;
  if (access_points.has_value()) {
    converted = std::vector<Service::AC::HostApInfo>();
    converted->reserve(access_points->size());
    for (const AccessPoint& access_point : *access_points) {
      converted->push_back(ToHostApInfo(access_point));
    }
  }

  std::lock_guard lock(AccessPointsMutex());
  StoredAccessPoints() = std::move(converted);
}

}  // namespace Wifi
