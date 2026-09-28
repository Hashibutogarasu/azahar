#include "game_scanner.h"

#include <lodepng.h>

#include <filesystem>
#include <functional>
#include <map>
#include <memory>

#include "common/string_util.h"
#include "core/loader/loader.h"
#include "core/loader/smdh.h"
#include "user_directory.h"

namespace GameScanner {

namespace {

namespace fs = std::filesystem;

const std::vector<std::string>& SupportedExtensions() {
  static const std::vector<std::string> extensions = {"3dsx", "elf", "axf",
                                                        "cci",  "cxi", "app"};
  return extensions;
}

bool HasSupportedExtension(const fs::path& path) {
  std::string extension = path.extension().string();
  if (!extension.empty() && extension.front() == '.') {
    extension.erase(0, 1);
  }
  extension = Common::ToLower(extension);
  const auto& extensions = SupportedExtensions();
  return std::find(extensions.begin(), extensions.end(), extension) != extensions.end();
}

std::string RegionsToString(const std::vector<Loader::SMDH::GameRegion>& regions) {
  static const std::map<Loader::SMDH::GameRegion, const char*> kRegionNames = {
      {Loader::SMDH::GameRegion::Japan, "Japan"},
      {Loader::SMDH::GameRegion::NorthAmerica, "North America"},
      {Loader::SMDH::GameRegion::Europe, "Europe"},
      {Loader::SMDH::GameRegion::Australia, "Australia"},
      {Loader::SMDH::GameRegion::China, "China"},
      {Loader::SMDH::GameRegion::Korea, "Korea"},
      {Loader::SMDH::GameRegion::Taiwan, "Taiwan"},
  };

  if (regions.empty()) {
    return "Invalid region";
  }

  const bool region_free =
      std::all_of(kRegionNames.begin(), kRegionNames.end(), [&regions](const auto& entry) {
        return std::find(regions.begin(), regions.end(), entry.first) != regions.end();
      });
  if (region_free) {
    return "Region free";
  }

  std::string result = kRegionNames.at(regions.front());
  for (auto it = std::next(regions.begin()); it != regions.end(); ++it) {
    result += ", " + std::string(kRegionNames.at(*it));
  }
  return result;
}

std::string WriteIconPng(const Loader::SMDH& smdh, const std::string& game_path) {
  const std::vector<u16> icon565 = smdh.GetIcon(true);
  constexpr int kSize = 48;
  if (icon565.size() != static_cast<std::size_t>(kSize * kSize)) {
    return "";
  }

  std::vector<unsigned char> rgba(kSize * kSize * 4);
  for (int i = 0; i < kSize * kSize; ++i) {
    const u16 pixel = icon565[i];
    const unsigned char r5 = (pixel >> 11) & 0x1F;
    const unsigned char g6 = (pixel >> 5) & 0x3F;
    const unsigned char b5 = pixel & 0x1F;
    rgba[i * 4 + 0] = static_cast<unsigned char>((r5 << 3) | (r5 >> 2));
    rgba[i * 4 + 1] = static_cast<unsigned char>((g6 << 2) | (g6 >> 4));
    rgba[i * 4 + 2] = static_cast<unsigned char>((b5 << 3) | (b5 >> 2));
    rgba[i * 4 + 3] = 255;
  }

  const std::string icons_dir = UserDataDirectory() + "/icons";
  fs::create_directories(icons_dir);
  const std::string icon_path =
      icons_dir + "/" + std::to_string(std::hash<std::string>{}(game_path)) + ".png";
  if (lodepng::encode(icon_path, rgba, kSize, kSize) != 0) {
    return "";
  }
  return icon_path;
}

bool IsSystemTitle(u64 program_id) {
  return ((program_id >> 32) & 0xFFFFFFFF) == 0x00040010;
}

void ScanDirectory(const fs::path& directory, int depth_remaining,
                    std::vector<GameEntry>& games) {
  if (depth_remaining <= 0) {
    return;
  }

  std::error_code error;
  for (const auto& entry : fs::directory_iterator(directory, error)) {
    if (entry.is_directory()) {
      ScanDirectory(entry.path(), depth_remaining - 1, games);
      continue;
    }
    if (!HasSupportedExtension(entry.path())) {
      continue;
    }

    const std::string path = entry.path().string();
    std::unique_ptr<Loader::AppLoader> loader = Loader::GetLoader(path);
    if (!loader) {
      continue;
    }

    bool executable = false;
    const Loader::ResultStatus executable_result = loader->IsExecutable(executable);
    if (!executable && executable_result != Loader::ResultStatus::ErrorEncrypted) {
      continue;
    }

    u64 program_id = 0;
    loader->ReadProgramId(program_id);

    std::vector<u8> smdh_data;
    loader->ReadIcon(smdh_data);

    GameEntry game;
    game.path = path;
    game.filename = entry.path().filename().string();
    game.title_id = program_id;
    game.is_system_title = IsSystemTitle(program_id);

    if (Loader::IsValidSMDH(smdh_data)) {
      Loader::SMDH smdh;
      std::memcpy(&smdh, smdh_data.data(), sizeof(Loader::SMDH));
      constexpr auto kLanguage = Loader::SMDH::TitleLanguage::English;
      game.title = Common::UTF16BufferToUTF8(smdh.GetLongTitle(kLanguage));
      game.company = Common::UTF16BufferToUTF8(smdh.titles[static_cast<std::size_t>(kLanguage)]
                                                     .publisher);
      game.regions = RegionsToString(smdh.GetRegions());
      game.is_visible_system_title = (smdh.flags & Loader::SMDH::Flags::Visible) != 0;
      game.icon_path = WriteIconPng(smdh, path);
    } else {
      game.title = game.filename;
      game.company = "";
      game.regions = executable_result == Loader::ResultStatus::ErrorEncrypted
                         ? "Encrypted"
                         : "Invalid region";
      game.is_visible_system_title = false;
    }

    games.push_back(std::move(game));
  }
}

}  // namespace

std::vector<GameEntry> ScanGames(const std::string& games_directory) {
  std::vector<GameEntry> games;
  if (games_directory.empty()) {
    return games;
  }
  ScanDirectory(fs::path(games_directory), 3, games);
  return games;
}

}  // namespace GameScanner
