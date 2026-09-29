#include "cia_install.h"

#include "core/hle/service/am/am.h"
#include "user_directory.h"

namespace CiaInstall {

std::vector<Result> InstallFiles(const std::vector<std::string>& paths) {
  EnsureUserPathInitialized();
  std::vector<Result> results;
  results.reserve(paths.size());
  for (const std::string& path : paths) {
    const Service::AM::InstallStatus status = Service::AM::InstallCIA(path);
    const std::size_t slash = path.find_last_of('/');
    const std::string filename = slash == std::string::npos ? path : path.substr(slash + 1);
    results.push_back({filename, status == Service::AM::InstallStatus::Success});
  }
  return results;
}

}  // namespace CiaInstall
