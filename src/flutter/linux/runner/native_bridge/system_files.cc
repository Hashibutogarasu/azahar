#include "system_files.h"

#include "common/file_util.h"
#include "core/hw/unique_data.h"
#include "core/system_titles.h"
#include "user_directory.h"

namespace SystemFiles {

bool IsFullConsoleLinked() {
  EnsureUserPathInitialized();
  return HW::UniqueData::IsFullConsoleLinked();
}

void UnlinkConsole() {
  EnsureUserPathInitialized();
  HW::UniqueData::UnlinkConsole();
}

std::pair<bool, bool> AreSystemTitlesInstalled() {
  EnsureUserPathInitialized();
  return Core::AreSystemTitlesInstalled();
}

void UninstallSystemFiles(bool old3ds) {
  EnsureUserPathInitialized();
  Core::UninstallSystemFiles(old3ds ? Core::SystemTitleSet::Old3ds
                                     : Core::SystemTitleSet::New3ds);
}

std::string GetHomeMenuPath(int region) {
  EnsureUserPathInitialized();
  const std::string path = Core::GetHomeMenuNcchPath(static_cast<u32>(region));
  return FileUtil::Exists(path) ? path : "";
}

}  // namespace SystemFiles
