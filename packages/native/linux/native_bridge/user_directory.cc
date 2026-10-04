#include "user_directory.h"

#include <glib.h>

#include "common/file_util.h"
#include "common/storage.h"

namespace {
constexpr char kAppDataDirName[] = "azahar";

std::string& ConfiguredUserDirectory() {
  static std::string directory;
  return directory;
}

std::string& AppliedUserDirectory() {
  static std::string directory;
  return directory;
}
}  // namespace

std::string UserDataDirectory() {
  std::string path = ConfiguredUserDirectory();
  if (path.empty()) {
    path = std::string(g_get_user_data_dir()) + "/" + kAppDataDirName;
  }
  g_mkdir_with_parents(path.c_str(), 0700);
  return path;
}

void SetUserDirectory(const std::string& path) {
  ConfiguredUserDirectory() = path;
  EnsureUserPathInitialized();
}

void EnsureUserPathInitialized() {
  const std::string directory = UserDataDirectory();
  if (AppliedUserDirectory() == directory) {
    return;
  }
  Common::Storage::SetRoot(directory);
  FileUtil::SetUserPath();
  AppliedUserDirectory() = directory;
}
