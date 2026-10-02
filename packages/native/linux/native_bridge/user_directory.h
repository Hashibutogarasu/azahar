// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#ifndef RUNNER_USER_DIRECTORY_H_
#define RUNNER_USER_DIRECTORY_H_

#include <string>

std::string UserDataDirectory();

// Makes [path] the user directory of the core, replacing the default one.
void SetUserDirectory(const std::string& path);

void EnsureUserPathInitialized();

#endif  // RUNNER_USER_DIRECTORY_H_
