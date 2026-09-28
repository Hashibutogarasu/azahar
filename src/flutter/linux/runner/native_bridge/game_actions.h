#ifndef RUNNER_GAME_ACTIONS_H_
#define RUNNER_GAME_ACTIONS_H_

#include <array>
#include <cstdint>
#include <string>

namespace GameActions {

enum class Folder { App, Save, Updates, Dlc, Extra, Textures, Mods };
enum class UninstallTarget { Cia, Updates, Dlc };
enum class ShaderBackend { OpenGL, Vulkan };

std::array<bool, 7> GetFolderStatus(uint64_t title_id, const std::string& path);
bool OpenFolder(uint64_t title_id, const std::string& path, Folder folder);
bool DeleteFolder(uint64_t title_id, const std::string& path, UninstallTarget target);
void DeleteShaderCache(uint64_t title_id, ShaderBackend backend);
void CreateShortcut(const std::string& path, const std::string& name,
                     const std::string& icon_file_path, bool stretch);

}  // namespace GameActions

#endif  // RUNNER_GAME_ACTIONS_H_
