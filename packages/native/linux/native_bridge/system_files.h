#ifndef RUNNER_SYSTEM_FILES_H_
#define RUNNER_SYSTEM_FILES_H_

#include <string>
#include <utility>

namespace SystemFiles {

bool IsFullConsoleLinked();
void UnlinkConsole();
std::pair<bool, bool> AreSystemTitlesInstalled();
void UninstallSystemFiles(bool old3ds);
std::string GetHomeMenuPath(int region);

}  // namespace SystemFiles

#endif  // RUNNER_SYSTEM_FILES_H_
