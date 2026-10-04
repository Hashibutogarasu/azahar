// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#pragma once

#include <functional>
#include <string>
#include <azahar_storage.h>
#include "common/common_types.h"

/**
 * The file operations of the Rust crate. The crate registers its table instead of the core
 * calling it directly, because the library of an Android session does not contain the crate and
 * receives the table from the application.
 */
namespace Common::Storage {

void Register(const AzaharStorageApi* api);

const AzaharStorageApi* Api();

bool Exists(const std::string& path);
bool IsDirectory(const std::string& path);
u64 GetSize(const std::string& path);
bool CreateDir(const std::string& path);
bool RemoveFile(const std::string& path);
bool RemoveDir(const std::string& path);
bool Rename(const std::string& from, const std::string& to);
bool Copy(const std::string& from, const std::string& to);
int Open(const std::string& path, const std::string& mode);
bool List(const std::string& path, const std::function<void(const std::string&)>& callback);
std::string UserPath();
bool SetRoot(const std::string& location);

} // namespace Common::Storage
