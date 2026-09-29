#ifndef RUNNER_GAME_SCANNER_H_
#define RUNNER_GAME_SCANNER_H_

#include <cstdint>
#include <string>
#include <vector>

namespace GameScanner {

struct GameEntry {
  std::string title;
  std::string description;
  std::string path;
  uint64_t title_id = 0;
  std::string company;
  std::string regions;
  bool is_installed = false;
  bool is_system_title = false;
  bool is_visible_system_title = false;
  std::string filename;
  std::string icon_path;
};

enum class InstalledTitleRoot { SdmcDir, NandDir };

struct InstalledTitlePath {
  InstalledTitleRoot root;
  std::string path;
};

std::vector<GameEntry> ScanGames(const std::string& games_directory,
                                  const std::vector<InstalledTitlePath>& installed_title_paths);

}  // namespace GameScanner

#endif  // RUNNER_GAME_SCANNER_H_
