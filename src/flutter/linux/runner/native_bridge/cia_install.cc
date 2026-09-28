#include "cia_install.h"

#include "core/hle/service/am/am.h"
#include "user_directory.h"

namespace CiaInstall {

void InstallFiles(const std::vector<std::string>& paths) {
  EnsureUserPathInitialized();
  for (const std::string& path : paths) {
    Service::AM::InstallCIA(path);
  }
}

}  // namespace CiaInstall
