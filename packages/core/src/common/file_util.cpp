// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

// Copyright Dolphin Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include <array>
#include <fstream>
#include <limits>
#include <memory>
#include <sstream>
#include <unordered_map>
#include <boost/iostreams/device/file_descriptor.hpp>
#include <boost/iostreams/stream.hpp>
#include <cryptopp/aes.h>
#include <cryptopp/modes.h>
#include <fmt/format.h>
#include "common/archives.h"
#include "common/assert.h"
#include "common/common_funcs.h"
#include "common/common_paths.h"
#include "common/error.h"
#include "common/file_util.h"
#include "common/logging/log.h"
#include "common/storage.h"
#include "common/string_util.h"

#include <algorithm>
#include <cstring>
#include <sys/stat.h>
#include <unistd.h>

// This namespace has various generic functions related to files and paths.
// The code still needs a ton of cleanup.
// REMEMBER: strdup considered harmful!
namespace FileUtil {

using Common::GetLastErrorMsg;

// Remove any ending forward slashes from directory paths
// Modifies argument.
static void StripTailDirSlashes(std::string& fname) {
    if (fname.length() <= 1) {
        return;
    }

    std::size_t i = fname.length();
    while (i > 0 && fname[i - 1] == DIR_SEP_CHR) {
        --i;
    }
    fname.resize(i);
}

bool Exists(const std::string& filename) {
    std::string copy(filename);
    StripTailDirSlashes(copy);
    return Common::Storage::Exists(copy);
}

bool IsDirectory(const std::string& filename) {
    std::string copy(filename);
    StripTailDirSlashes(copy);
    return Common::Storage::IsDirectory(copy);
}

bool Delete(const std::string& filename) {
    LOG_TRACE(Common_Filesystem, "file {}", filename);

    // Return true because we care about the file no
    // being there, not the actual delete.
    if (!Exists(filename)) {
        LOG_DEBUG(Common_Filesystem, "{} does not exist", filename);
        return true;
    }

    // We can't delete a directory
    if (IsDirectory(filename)) {
        LOG_ERROR(Common_Filesystem, "Failed: {} is a directory", filename);
        return false;
    }

    if (!Common::Storage::RemoveFile(filename)) {
        LOG_ERROR(Common_Filesystem, "Deleting {} failed", filename);
        return false;
    }

    return true;
}

bool CreateDir(const std::string& path) {
    LOG_TRACE(Common_Filesystem, "directory {}", path);
    if (Common::Storage::CreateDir(path)) {
        return true;
    }
    LOG_ERROR(Common_Filesystem, "Creating the directory {} failed", path);
    return false;
}

bool CreateFullPath(const std::string& fullPath) {
    int panicCounter = 100;
    LOG_TRACE(Common_Filesystem, "path {}", fullPath);

    if (FileUtil::Exists(fullPath)) {
        LOG_DEBUG(Common_Filesystem, "path exists {}", fullPath);
        return true;
    }

    std::size_t position = 0;
    while (true) {
        std::size_t prev_pos = position;
        // Find next sub path
        position = fullPath.find(DIR_SEP_CHR, prev_pos);

        // we're done, yay!
        if (position == fullPath.npos)
            return true;

        // Include the '/' so the first call is CreateDir("/") rather than CreateDir("")
        std::string const subPath(fullPath.substr(0, position + 1));
        if (!FileUtil::IsDirectory(subPath) && !FileUtil::CreateDir(subPath)) {
            LOG_ERROR(Common, "CreateFullPath: directory creation failed");
            return false;
        }

        // A safety check
        panicCounter--;
        if (panicCounter <= 0) {
            LOG_ERROR(Common, "CreateFullPath: directory structure is too deep");
            return false;
        }
        position++;
    }
}

bool DeleteDir(const std::string& filename) {
    LOG_TRACE(Common_Filesystem, "directory {}", filename);

    // check if a directory
    if (!FileUtil::IsDirectory(filename)) {
        LOG_ERROR(Common_Filesystem, "Not a directory {}", filename);
        return false;
    }

    if (Common::Storage::RemoveDir(filename))
        return true;
    LOG_ERROR(Common_Filesystem, "Deleting the directory {} failed", filename);

    return false;
}

bool Rename(const std::string& srcFilename, const std::string& destFilename) {
    LOG_TRACE(Common_Filesystem, "{} --> {}", srcFilename, destFilename);
    if (Common::Storage::Rename(srcFilename, destFilename))
        return true;
    LOG_ERROR(Common_Filesystem, "Renaming {} to {} failed", srcFilename, destFilename);
    return false;
}

bool Copy(const std::string& srcFilename, const std::string& destFilename) {
    LOG_TRACE(Common_Filesystem, "{} --> {}", srcFilename, destFilename);
    if (Common::Storage::Copy(srcFilename, destFilename))
        return true;
    LOG_ERROR(Common_Filesystem, "Copying {} to {} failed", srcFilename, destFilename);
    return false;
}

u64 GetSize(const std::string& filename) {
    if (!Exists(filename)) {
        LOG_ERROR(Common_Filesystem, "failed {}: No such file", filename);
        return 0;
    }

    if (IsDirectory(filename)) {
        LOG_ERROR(Common_Filesystem, "failed {}: is a directory", filename);
        return 0;
    }

    const u64 size = Common::Storage::GetSize(filename);
    LOG_TRACE(Common_Filesystem, "{}: {}", filename, size);
    return size;
}

u64 GetSize(const int fd) {
    struct stat buf;
    if (fstat(fd, &buf) != 0) {
        LOG_ERROR(Common_Filesystem, "GetSize: stat failed {}: {}", fd, GetLastErrorMsg());
        return 0;
    }
    return buf.st_size;
}

u64 GetSize(FILE* f) {
    // can't use off_t here because it can be 32-bit
    u64 pos = ftello(f);
    if (fseeko(f, 0, SEEK_END) != 0) {
        LOG_ERROR(Common_Filesystem, "GetSize: seek failed {}: {}", fmt::ptr(f), GetLastErrorMsg());
        return 0;
    }
    u64 size = ftello(f);
    if ((size != pos) && (fseeko(f, pos, SEEK_SET) != 0)) {
        LOG_ERROR(Common_Filesystem, "GetSize: seek failed {}: {}", fmt::ptr(f), GetLastErrorMsg());
        return 0;
    }
    return size;
}

bool CreateEmptyFile(const std::string& filename) {
    LOG_TRACE(Common_Filesystem, "{}", filename);

    if (!FileUtil::IOFile(filename, "wb").IsOpen()) {
        LOG_ERROR(Common_Filesystem, "failed {}: {}", filename, GetLastErrorMsg());
        return false;
    }

    return true;
}

bool ForeachDirectoryEntry(u64* num_entries_out, const std::string& directory,
                           DirectoryEntryCallable callback) {
    LOG_TRACE(Common_Filesystem, "directory {}", directory);

    // How many files + directories we found
    u64 found_entries = 0;

    // Save the status of callback function
    bool callback_error = false;

    std::vector<std::string> names;
    if (!Common::Storage::List(directory,
                               [&names](const std::string& name) { names.push_back(name); })) {
        return false;
    }

    for (const std::string& virtual_name : names) {
        if (virtual_name == "." || virtual_name == "..")
            continue;

        u64 ret_entries = 0;
        if (!callback(&ret_entries, directory, virtual_name)) {
            callback_error = true;
            break;
        }
        found_entries += ret_entries;
    }

    if (callback_error)
        return false;

    // num_entries_out is allowed to be specified nullptr, in which case we shouldn't try to set it
    if (num_entries_out != nullptr)
        *num_entries_out = found_entries;
    return true;
}

u64 ScanDirectoryTree(const std::string& directory, FSTEntry& parent_entry, unsigned int recursion,
                      std::atomic<bool>* stop_flag) {
    const auto callback = [recursion, &parent_entry,
                           stop_flag](u64* num_entries_out, const std::string& directory,
                                      const std::string& virtual_name) -> bool {
        // Break early and return error if stop is requested
        if (stop_flag && *stop_flag) {
            return false;
        }

        FSTEntry entry;
        entry.virtualName = virtual_name;
        entry.physicalName = directory + DIR_SEP + virtual_name;

        if (IsDirectory(entry.physicalName)) {
            entry.isDirectory = true;
            // is a directory, lets go inside if we didn't recurse to often
            if (recursion > 0) {
                entry.size = ScanDirectoryTree(entry.physicalName, entry, recursion - 1);
                *num_entries_out += entry.size;
            } else {
                entry.size = 0;
            }
        } else { // is a file
            entry.isDirectory = false;
            entry.size = GetSize(entry.physicalName);
        }
        (*num_entries_out)++;

        // Push into the tree
        parent_entry.children.push_back(std::move(entry));
        return true;
    };

    u64 num_entries;
    return ForeachDirectoryEntry(&num_entries, directory, callback) ? num_entries : 0;
}

void GetAllFilesFromNestedEntries(FSTEntry& directory, std::vector<FSTEntry>& output) {
    std::vector<FSTEntry> files;
    for (auto& entry : directory.children) {
        if (entry.isDirectory) {
            GetAllFilesFromNestedEntries(entry, output);
        } else {
            output.push_back(entry);
        }
    }
}

bool DeleteDirRecursively(const std::string& directory, unsigned int recursion) {
    const auto callback = [recursion]([[maybe_unused]] u64* num_entries_out,
                                      const std::string& directory,
                                      const std::string& virtual_name) -> bool {
        std::string new_path = directory + DIR_SEP_CHR + virtual_name;

        if (IsDirectory(new_path)) {
            if (recursion == 0)
                return false;
            return DeleteDirRecursively(new_path, recursion - 1);
        }
        return Delete(new_path);
    };

    if (!ForeachDirectoryEntry(nullptr, directory, callback))
        return false;

    // Delete the outermost directory
    FileUtil::DeleteDir(directory);
    return true;
}

void CopyDir(const std::string& source_path, const std::string& dest_path) {
    if (source_path == dest_path)
        return;
    if (!FileUtil::Exists(source_path))
        return;
    if (!FileUtil::Exists(dest_path))
        FileUtil::CreateFullPath(dest_path);

    std::vector<std::string> names;
    if (!Common::Storage::List(source_path,
                               [&names](const std::string& name) { names.push_back(name); })) {
        return;
    }

    for (const std::string& virtualName : names) {
        if (virtualName == "." || virtualName == "..")
            continue;

        std::string source, dest;
        source = source_path + virtualName;
        dest = dest_path + virtualName;
        if (IsDirectory(source)) {
            source += '/';
            dest += '/';
            if (!FileUtil::Exists(dest))
                FileUtil::CreateFullPath(dest);
            CopyDir(source, dest);
        } else if (!FileUtil::Exists(dest))
            FileUtil::Copy(source, dest);
    }
}

namespace {
std::unordered_map<UserPath, std::string> g_paths;
std::unordered_map<UserPath, std::string> g_default_paths;
} // namespace

void SetUserPath() {
    const std::string user_path = Common::Storage::UserPath();
    if (!CreateFullPath(user_path)) {
        LOG_ERROR(Common_Filesystem, "Creating the user directory {} failed", user_path);
    }
    LOG_INFO(Common_Filesystem, "Using {} as the user directory", user_path);

    g_paths.insert_or_assign(UserPath::UserDir, user_path);
    g_paths.insert_or_assign(UserPath::ConfigDir, user_path + CONFIG_DIR DIR_SEP);
    g_paths.insert_or_assign(UserPath::CacheDir, user_path + CACHE_DIR DIR_SEP);
    g_paths.insert_or_assign(UserPath::SDMCDir, user_path + SDMC_DIR DIR_SEP);
    g_paths.insert_or_assign(UserPath::NANDDir, user_path + NAND_DIR DIR_SEP);
    g_paths.insert_or_assign(UserPath::SysDataDir, user_path + SYSDATA_DIR DIR_SEP);
    g_paths.insert_or_assign(UserPath::LogDir, user_path + LOG_DIR DIR_SEP);
    g_paths.insert_or_assign(UserPath::CheatsDir, user_path + CHEATS_DIR DIR_SEP);
    g_paths.insert_or_assign(UserPath::DLLDir, user_path + DLL_DIR DIR_SEP);
    g_paths.insert_or_assign(UserPath::ShaderDir, user_path + SHADER_DIR DIR_SEP);
    g_paths.insert_or_assign(UserPath::DumpDir, user_path + DUMP_DIR DIR_SEP);
    g_paths.insert_or_assign(UserPath::LoadDir, user_path + LOAD_DIR DIR_SEP);
    g_paths.insert_or_assign(UserPath::StatesDir, user_path + STATES_DIR DIR_SEP);
    g_paths.insert_or_assign(UserPath::IconsDir, user_path + ICONS_DIR DIR_SEP);
    g_paths.insert_or_assign(UserPath::PlayTimeDir, user_path + LOG_DIR DIR_SEP);
    g_default_paths = g_paths;
}

std::string g_currentRomPath{};

void SetCurrentRomPath(const std::string& path) {
    g_currentRomPath = path;
}

bool StringReplace(std::string& haystack, const std::string& a, const std::string& b, bool swap) {
    const auto& needle = swap ? b : a;
    const auto& replacement = swap ? a : b;
    if (needle.empty()) {
        return false;
    }
    auto index = haystack.find(needle, 0);
    if (index == std::string::npos) {
        return false;
    }
    haystack.replace(index, needle.size(), replacement);
    return true;
}

std::string SerializePath(const std::string& input, bool is_saving) {
    auto result = input;
    StringReplace(result, "%CITRA_ROM_FILE%", g_currentRomPath, is_saving);
    StringReplace(result, "%CITRA_USER_DIR%", GetUserPath(UserPath::UserDir), is_saving);
    return result;
}

const std::string& GetUserPath(UserPath path) {
    // Set up all paths and files on the first run
    if (g_paths.empty())
        SetUserPath();
    return g_paths[path];
}

const std::string& GetDefaultUserPath(UserPath path) {
    // Set up all paths and files on the first run
    if (g_default_paths.empty())
        SetUserPath();
    return g_default_paths[path];
}

void UpdateUserPath(UserPath path, const std::string& filename) {
    if (filename.empty()) {
        return;
    }
    if (!FileUtil::IsDirectory(filename)) {
        LOG_ERROR(Common_Filesystem, "Path is not a directory. UserPath: {}  filename: {}", path,
                  filename);
        return;
    }
    g_paths[path] = SanitizePath(filename) + DIR_SEP;
}

std::size_t WriteStringToFile(bool text_file, const std::string& filename, std::string_view str) {
    return IOFile(filename, text_file ? "w" : "wb").WriteString(str);
}

std::size_t ReadFileToString(bool text_file, const std::string& filename, std::string& str) {
    IOFile file(filename, text_file ? "r" : "rb");

    if (!file.IsOpen())
        return 0;

    str.resize(static_cast<u32>(file.GetSize()));
    return file.ReadArray(str.data(), str.size());
}

void SplitFilename83(const std::string& filename, std::array<char, 9>& short_name,
                     std::array<char, 4>& extension) {
    const std::string forbidden_characters = ".\"/\\[]:;=, ";

    // On a FAT32 partition, 8.3 names are stored as a 11 bytes array, filled with spaces.
    short_name = {{' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '\0'}};
    extension = {{' ', ' ', ' ', '\0'}};

    std::string::size_type point = filename.rfind('.');
    if (point == filename.size() - 1)
        point = filename.rfind('.', point);

    // Get short name.
    int j = 0;
    for (char letter : filename.substr(0, point)) {
        if (forbidden_characters.find(letter, 0) != std::string::npos)
            continue;
        if (j == 8) {
            // TODO(Link Mauve): also do that for filenames containing a space.
            // TODO(Link Mauve): handle multiple files having the same short name.
            short_name[6] = '~';
            short_name[7] = '1';
            break;
        }
        short_name[j++] = Common::ToUpper(letter);
    }

    // Get extension.
    if (point != std::string::npos) {
        j = 0;
        for (char letter : filename.substr(point + 1, 3))
            extension[j++] = Common::ToUpper(letter);
    }
}

std::vector<std::string> SplitPathComponents(std::string_view filename) {
    std::string copy(filename);
    std::replace(copy.begin(), copy.end(), '\\', '/');
    std::vector<std::string> out;

    std::stringstream stream(copy);
    std::string item;
    while (std::getline(stream, item, '/')) {
        out.push_back(std::move(item));
    }

    return out;
}

std::string_view GetParentPath(std::string_view path) {
    const auto name_bck_index = path.rfind('\\');
    const auto name_fwd_index = path.rfind('/');
    std::size_t name_index;

    if (name_bck_index == std::string_view::npos || name_fwd_index == std::string_view::npos) {
        name_index = std::min(name_bck_index, name_fwd_index);
    } else {
        name_index = std::max(name_bck_index, name_fwd_index);
    }

    return path.substr(0, name_index);
}

std::string_view GetPathWithoutTop(std::string_view path) {
    if (path.empty()) {
        return path;
    }

    while (path[0] == '\\' || path[0] == '/') {
        path.remove_prefix(1);
        if (path.empty()) {
            return path;
        }
    }

    const auto name_bck_index = path.find('\\');
    const auto name_fwd_index = path.find('/');
    return path.substr(std::min(name_bck_index, name_fwd_index) + 1);
}

std::string_view GetFilename(std::string_view path) {
    const auto name_index = path.find_last_of("\\/");

    if (name_index == std::string_view::npos) {
        return path;
    }

    return path.substr(name_index + 1);
}

std::string_view GetExtensionFromFilename(std::string_view name) {
    const std::size_t index = name.rfind('.');

    if (index == std::string_view::npos) {
        return {};
    }

    return name.substr(index + 1);
}

std::string_view RemoveTrailingSlash(std::string_view path) {
    if (path.empty()) {
        return path;
    }

    if (path.back() == '\\' || path.back() == '/') {
        path.remove_suffix(1);
        return path;
    }

    return path;
}

std::string SanitizePath(std::string_view path_, DirectorySeparator directory_separator) {
    std::string path(path_);
    const char type1 = directory_separator == DirectorySeparator::BackwardSlash ? '/' : '\\';
    const char type2 = directory_separator == DirectorySeparator::BackwardSlash ? '\\' : '/';

    std::replace(path.begin(), path.end(), type1, type2);

    const std::size_t scheme_end = path.find("://");
    auto start = scheme_end == std::string::npos ? path.begin() : path.begin() + scheme_end + 3;
    path.erase(std::unique(start, path.end(),
                           [type2](char c1, char c2) { return c1 == type2 && c2 == type2; }),
               path.end());
    return std::string(RemoveTrailingSlash(path));
}

IOFile::IOFile() = default;

IOFile::IOFile(const std::string& filename, const char openmode[], int flags)
    : filename(filename), openmode(openmode), flags(flags) {
    Open();
}

IOFile::~IOFile() {
    Close();
}

IOFile::IOFile(IOFile&& other) noexcept {
    Swap(other);
}

IOFile& IOFile::operator=(IOFile&& other) noexcept {
    Swap(other);
    return *this;
}

void IOFile::Swap(IOFile& other) noexcept {
    std::swap(m_file, other.m_file);
    std::swap(m_good, other.m_good);
    std::swap(filename, other.filename);
    std::swap(openmode, other.openmode);
    std::swap(flags, other.flags);
}

bool IOFile::Open() {
    Close();

    const int fd = Common::Storage::Open(filename, openmode);
    if (fd != -1) {
        m_file = fdopen(fd, openmode.c_str());
        if (m_file == nullptr) {
            LOG_ERROR(Common_Filesystem, "Error on file: {}, error: {}", filename,
                      strerror(errno));
            close(fd);
        }
    }

    m_good = m_file != nullptr;
    return m_good;
}

bool IOFile::Close() {
    if (!IsOpen() || 0 != std::fclose(m_file))
        m_good = false;

    m_file = nullptr;
    return m_good;
}

u64 IOFile::GetSize() const {
    if (IsOpen())
        return FileUtil::GetSize(m_file);

    return 0;
}

bool IOFile::SeekImpl(s64 off, int origin) {
    if (!IsOpen() || 0 != fseeko(m_file, off, origin))
        m_good = false;

    return m_good;
}

u64 IOFile::Tell() const {
    if (IsOpen())
        return ftello(m_file);

    return std::numeric_limits<u64>::max();
}

bool IOFile::Flush() {
    if (!IsOpen() || 0 != std::fflush(m_file))
        m_good = false;

    return m_good;
}

std::size_t IOFile::ReadImpl(void* data, std::size_t length, std::size_t data_size) {
    if (!IsOpen()) {
        m_good = false;
        return std::numeric_limits<std::size_t>::max();
    }

    if (length == 0) {
        return 0;
    }

    DEBUG_ASSERT(data != nullptr);

    return std::fread(data, data_size, length, m_file);
}

std::size_t IOFile::ReadAtImpl(void* data, std::size_t length, std::size_t data_size,
                               std::size_t offset) {
    if (!IsOpen()) {
        m_good = false;
        return std::numeric_limits<std::size_t>::max();
    }

    if (length == 0) {
        return 0;
    }

    DEBUG_ASSERT(data != nullptr);

    return ::pread(fileno(m_file), data, data_size * length, offset);
}

std::size_t IOFile::WriteImpl(const void* data, std::size_t length, std::size_t data_size) {
    if (!IsOpen()) {
        m_good = false;
        return std::numeric_limits<std::size_t>::max();
    }

    if (length == 0) {
        return 0;
    }

    DEBUG_ASSERT(data != nullptr);

    return std::fwrite(data, data_size, length, m_file);
}

bool IOFile::Resize(u64 size) {
    if (!IsOpen() || 0 != ftruncate(fileno(m_file), size))
        m_good = false;

    return m_good;
}

struct CryptoIOFileImpl {

    std::vector<u8> key;
    std::vector<u8> iv;

    CryptoPP::CTR_Mode<CryptoPP::AES>::Decryption d;
    CryptoPP::CTR_Mode<CryptoPP::AES>::Encryption e;

    std::vector<u8> write_buffer;

    std::size_t ReadImpl(CryptoIOFile& f, void* data, std::size_t length, std::size_t data_size) {
        std::size_t res = f.IOFile::ReadImpl(data, length, data_size);
        if (res != std::numeric_limits<std::size_t>::max() && res != 0) {
            d.ProcessData(reinterpret_cast<CryptoPP::byte*>(data),
                          reinterpret_cast<CryptoPP::byte*>(data), length * data_size);
            e.Seek(f.IOFile::Tell());
        }
        return res;
    }

    std::size_t ReadAtImpl(CryptoIOFile& f, void* data, std::size_t length, std::size_t data_size,
                           std::size_t offset) {
        std::size_t res = f.IOFile::ReadAtImpl(data, length, data_size, offset);
        if (res != std::numeric_limits<std::size_t>::max() && res != 0) {
            d.Seek(offset);
            d.ProcessData(reinterpret_cast<CryptoPP::byte*>(data),
                          reinterpret_cast<CryptoPP::byte*>(data), length * data_size);
            e.Seek(f.IOFile::Tell());
        }
        return res;
    }

    std::size_t WriteImpl(CryptoIOFile& f, const void* data, std::size_t length,
                          std::size_t data_size) {
        if (write_buffer.size() < length * data_size) {
            write_buffer.resize(length * data_size);
        }
        e.ProcessData(write_buffer.data(), reinterpret_cast<const CryptoPP::byte*>(data),
                      length * data_size);
        std::size_t res = f.IOFile::WriteImpl(write_buffer.data(), length, data_size);
        if (res != std::numeric_limits<std::size_t>::max() && res != 0) {
            d.Seek(f.IOFile::Tell());
        }
        return res;
    }

    bool SeekImpl(CryptoIOFile& f, s64 off, int origin) {
        bool res = f.IOFile::SeekImpl(off, origin);
        if (res) {
            u64 pos = f.IOFile::Tell();
            d.Seek(pos);
            e.Seek(pos);
        }
        return res;
    }
};

CryptoIOFile::CryptoIOFile() : IOFile() {
    impl = std::make_unique<CryptoIOFileImpl>();
}

CryptoIOFile::CryptoIOFile(const std::string& filename, const char openmode[],
                           const std::vector<u8>& aes_key, const std::vector<u8>& aes_iv, int flags)
    : IOFile(filename, openmode, flags) {
    impl = std::make_unique<CryptoIOFileImpl>();
    impl->key = aes_key;
    impl->iv = aes_iv;
    impl->d.SetKeyWithIV(aes_key.data(), aes_key.size(), aes_iv.data());
    impl->e.SetKeyWithIV(aes_key.data(), aes_key.size(), aes_iv.data());
}

CryptoIOFile::~CryptoIOFile() {}

std::size_t CryptoIOFile::ReadImpl(void* data, std::size_t length, std::size_t data_size) {
    return impl->ReadImpl(*this, data, length, data_size);
}

std::size_t CryptoIOFile::ReadAtImpl(void* data, std::size_t length, std::size_t data_size,
                                     std::size_t offset) {
    return impl->ReadAtImpl(*this, data, length, data_size, offset);
}

std::size_t CryptoIOFile::WriteImpl(const void* data, std::size_t length, std::size_t data_size) {
    return impl->WriteImpl(*this, data, length, data_size);
}

bool CryptoIOFile::SeekImpl(s64 off, int origin) {
    return impl->SeekImpl(*this, off, origin);
}

template <class Archive>
void CryptoIOFile::serialize(Archive& ar, const unsigned int) {
    ar & impl->key;
    ar & impl->iv;
    if (Archive::is_loading::value) {
        impl->e.SetKeyWithIV(impl->key.data(), impl->key.size(), impl->iv.data());
        impl->d.SetKeyWithIV(impl->key.data(), impl->key.size(), impl->iv.data());
    }
    ar& boost::serialization::base_object<IOFile>(*this);
}

template <typename T>
using boost_iostreams = boost::iostreams::stream<T>;

template <>
void OpenFStream<std::ios_base::in>(
    boost_iostreams<boost::iostreams::file_descriptor_source>& fstream,
    const std::string& filename) {
    IOFile file(filename, "r");
    if (file.GetFd() == -1)
        return;
    int fd = dup(file.GetFd());
    if (fd == -1)
        return;
    boost::iostreams::file_descriptor_source file_descriptor_source(fd,
                                                                    boost::iostreams::close_handle);
    fstream.open(file_descriptor_source);
}

template <>
void OpenFStream<std::ios_base::out>(
    boost_iostreams<boost::iostreams::file_descriptor_sink>& fstream, const std::string& filename) {
    IOFile file(filename, "w");
    if (file.GetFd() == -1)
        return;
    int fd = dup(file.GetFd());
    if (fd == -1)
        return;
    boost::iostreams::file_descriptor_sink file_descriptor_sink(fd, boost::iostreams::close_handle);
    fstream.open(file_descriptor_sink);
}
} // namespace FileUtil

SERIALIZE_EXPORT_IMPL(FileUtil::IOFile)
SERIALIZE_EXPORT_IMPL(FileUtil::CryptoIOFile)
