#include "user_directory.h"

#include <glib.h>

#include "common/file_util.h"

namespace {
constexpr char kAppDataDirName[] = "azahar";
}

std::string UserDataDirectory() {
  std::string path = std::string(g_get_user_data_dir()) + "/" + kAppDataDirName;
  g_mkdir_with_parents(path.c_str(), 0700);
  return path;
}

void EnsureUserPathInitialized() {
  static const bool initialized = [] {
    FileUtil::SetUserPath(UserDataDirectory() + "/");
    return true;
  }();
  (void)initialized;
}
