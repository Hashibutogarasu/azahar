// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include <atomic>
#include "common/logging/log.h"
#include "common/storage.h"

namespace Common::Storage {

namespace {
std::atomic<const AzaharStorageApi*> g_api{nullptr};

/**
 * Logs instead of crashing, since a missing table only happens when a frontend forgot to
 * register it and every file operation then fails visibly in the log.
 */
const AzaharStorageApi* Table() {
    const AzaharStorageApi* api = g_api.load(std::memory_order_acquire);
    if (api == nullptr) {
        LOG_CRITICAL(Common_Filesystem, "No storage is registered");
    }
    return api;
}
} // Anonymous namespace

void Register(const AzaharStorageApi* api) {
    g_api.store(api, std::memory_order_release);
}

const AzaharStorageApi* Api() {
    return g_api.load(std::memory_order_acquire);
}

bool Exists(const std::string& path) {
    const auto* api = Table();
    return api != nullptr && api->exists(path.c_str()) != 0;
}

bool IsDirectory(const std::string& path) {
    const auto* api = Table();
    return api != nullptr && api->is_directory(path.c_str()) != 0;
}

u64 GetSize(const std::string& path) {
    const auto* api = Table();
    return api != nullptr ? api->size(path.c_str()) : 0;
}

bool CreateDir(const std::string& path) {
    const auto* api = Table();
    return api != nullptr && api->create_dir(path.c_str()) != 0;
}

bool RemoveFile(const std::string& path) {
    const auto* api = Table();
    return api != nullptr && api->remove_file(path.c_str()) != 0;
}

bool RemoveDir(const std::string& path) {
    const auto* api = Table();
    return api != nullptr && api->remove_dir(path.c_str()) != 0;
}

bool Rename(const std::string& from, const std::string& to) {
    const auto* api = Table();
    return api != nullptr && api->rename(from.c_str(), to.c_str()) != 0;
}

bool Copy(const std::string& from, const std::string& to) {
    const auto* api = Table();
    return api != nullptr && api->copy(from.c_str(), to.c_str()) != 0;
}

int Open(const std::string& path, const std::string& mode) {
    const auto* api = Table();
    return api != nullptr ? api->open(path.c_str(), mode.c_str()) : -1;
}

bool List(const std::string& path, const std::function<void(const std::string&)>& callback) {
    const auto* api = Table();
    if (api == nullptr) {
        return false;
    }
    const auto entry = [](void* user, const char* name) {
        (*static_cast<const std::function<void(const std::string&)>*>(user))(name);
    };
    return api->list(path.c_str(),
                     const_cast<void*>(static_cast<const void*>(&callback)), entry) != 0;
}

std::string UserPath() {
    const auto* api = Table();
    return api != nullptr ? std::string(api->user_path()) : std::string("/");
}

bool SetRoot(const std::string& location) {
    const auto* api = Table();
    return api != nullptr && api->set_root(location.c_str()) != 0;
}

} // namespace Common::Storage
