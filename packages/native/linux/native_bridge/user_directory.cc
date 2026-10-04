#include "user_directory.h"

#include <glib.h>

#include <mutex>

#include "common/file_util.h"
#include "common/storage.h"

namespace {
constexpr char kAppDataDirName[] = "azahar";

/**
 * Guards the user directory, because confirming a new one runs on a worker thread while the
 * other methods read it on the main thread. It is recursive since setting the directory applies
 * it through the same functions the readers use.
 */
std::recursive_mutex& UserDirectoryMutex() {
  static std::recursive_mutex mutex;
  return mutex;
}

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
  std::lock_guard lock{UserDirectoryMutex()};
  std::string path = ConfiguredUserDirectory();
  if (path.empty()) {
    path = std::string(g_get_user_data_dir()) + "/" + kAppDataDirName;
  }
  g_mkdir_with_parents(path.c_str(), 0700);
  return path;
}

void SetUserDirectory(const std::string& path) {
  std::lock_guard lock{UserDirectoryMutex()};
  ConfiguredUserDirectory() = path;
  EnsureUserPathInitialized();
}

void EnsureUserPathInitialized() {
  std::lock_guard lock{UserDirectoryMutex()};
  const std::string directory = UserDataDirectory();
  if (AppliedUserDirectory() == directory) {
    return;
  }
  Common::Storage::SetRoot(directory);
  FileUtil::SetUserPath();
  AppliedUserDirectory() = directory;
}
