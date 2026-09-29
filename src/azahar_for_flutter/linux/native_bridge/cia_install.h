#ifndef RUNNER_CIA_INSTALL_H_
#define RUNNER_CIA_INSTALL_H_

#include <string>
#include <vector>

namespace CiaInstall {

struct Result {
  std::string filename;
  bool success = false;
};

std::vector<Result> InstallFiles(const std::vector<std::string>& paths);

}  // namespace CiaInstall

#endif  // RUNNER_CIA_INSTALL_H_
