#ifndef RUNNER_WIFI_H_
#define RUNNER_WIFI_H_

#include <optional>
#include <string>
#include <vector>

namespace Wifi {

struct AccessPoint {
  std::string ssid;
  std::string bssid;
  int channel = 0;
  int level = 0;
};

void SetVirtualAccessPoints(std::optional<std::vector<AccessPoint>> access_points);

}  // namespace Wifi

#endif  // RUNNER_WIFI_H_
