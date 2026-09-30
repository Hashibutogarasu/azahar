// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include <memory>
#include <string_view>

#include "common/file_util.h"
#include "common/literals.h"
#include "common/logging/file_sink.h"

#ifdef _WIN32
#include <share.h>
#else
#define _SH_DENYWR 0
#endif

namespace Common::Log {

namespace {

constexpr std::string_view TEXT_EXTENSION = ".txt";
constexpr std::string_view OLD_TEXT_EXTENSION = ".old.txt";

std::string OldFilename(const std::string& filename) {
    if (filename.ends_with(TEXT_EXTENSION)) {
        return filename.substr(0, filename.size() - TEXT_EXTENSION.size())
            .append(OLD_TEXT_EXTENSION);
    }
    return filename + ".old";
}

class FileWriter {
public:
    explicit FileWriter(const std::string& filename) {
        static_cast<void>(FileUtil::CreateFullPath(filename));
        const auto old_filename = OldFilename(filename);
        static_cast<void>(FileUtil::Delete(old_filename));
        static_cast<void>(FileUtil::Rename(filename, old_filename));
        file = std::make_unique<FileUtil::IOFile>(filename, "w", _SH_DENYWR);
    }

    void Write(std::string_view line) {
        if (!enabled) {
            return;
        }
        using namespace Common::Literals;
        constexpr std::size_t write_limit = 100_MiB;
        bytes_written += file->WriteString(std::string{line}.append(1, '\n'));
        if (bytes_written > write_limit) {
            enabled = false;
            file->Flush();
        }
    }

    void Flush() {
        file->Flush();
    }

private:
    std::unique_ptr<FileUtil::IOFile> file;
    bool enabled = true;
    std::size_t bytes_written = 0;
};

} // namespace

Sink MakeFileSink(const std::string& filename) {
    auto writer = std::make_shared<FileWriter>(filename);
    return Sink{
        .write = [writer](std::string_view line) { writer->Write(line); },
        .flush = [writer] { writer->Flush(); },
    };
}

} // namespace Common::Log
