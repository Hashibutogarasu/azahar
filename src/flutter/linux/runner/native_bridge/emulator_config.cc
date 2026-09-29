#include "emulator_config.h"

#include <filesystem>
#include <fstream>

#include "user_directory.h"

namespace EmulatorConfig {

namespace {

namespace fs = std::filesystem;

std::string ConfigFilePath() {
  return UserDataDirectory() + "/config/config.ini";
}

std::string Trim(const std::string& value) {
  const auto begin = value.find_first_not_of(" \t\r\n");
  if (begin == std::string::npos) {
    return "";
  }
  const auto end = value.find_last_not_of(" \t\r\n");
  return value.substr(begin, end - begin + 1);
}

}  // namespace

Sections Read() {
  Sections sections;
  std::ifstream file(ConfigFilePath());
  if (!file.is_open()) {
    return sections;
  }

  std::string line;
  std::string current_section;
  while (std::getline(file, line)) {
    const std::string trimmed = Trim(line);
    if (trimmed.size() >= 2 && trimmed.front() == '[' && trimmed.back() == ']') {
      current_section = trimmed.substr(1, trimmed.size() - 2);
      sections.try_emplace(current_section);
      continue;
    }

    const auto separator = trimmed.find('=');
    if (separator == std::string::npos || separator == 0 || current_section.empty()) {
      continue;
    }

    const std::string key = Trim(trimmed.substr(0, separator));
    const std::string value = Trim(trimmed.substr(separator + 1));
    if (!value.empty()) {
      sections[current_section][key] = value;
    }
  }
  return sections;
}

void Write(const Sections& sections) {
  const std::string path = ConfigFilePath();
  Sections merged = Read();
  for (const auto& [section, keys] : sections) {
    for (const auto& [key, value] : keys) {
      merged[section][key] = value;
    }
  }

  fs::create_directories(fs::path(path).parent_path());
  std::ofstream file(path, std::ios::trunc);
  for (const auto& [section, keys] : merged) {
    file << "[" << section << "]\n";
    for (const auto& [key, value] : keys) {
      file << key << " = " << value << "\n";
    }
    file << "\n";
  }
}

}  // namespace EmulatorConfig
