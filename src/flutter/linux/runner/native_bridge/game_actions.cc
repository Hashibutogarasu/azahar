#include "game_actions.h"

#include <gio/gio.h>
#include <unistd.h>

#include <cstdio>
#include <filesystem>
#include <fstream>

#include "common/file_util.h"
#include "user_directory.h"

namespace GameActions {

namespace {

namespace fs = std::filesystem;

std::string TitleIdHexLower(uint64_t title_id) {
  char buffer[17];
  std::snprintf(buffer, sizeof(buffer), "%016lx", static_cast<unsigned long>(title_id));
  return buffer;
}

std::string TitleIdHexUpper(uint64_t title_id) {
  char buffer[17];
  std::snprintf(buffer, sizeof(buffer), "%016lX", static_cast<unsigned long>(title_id));
  return buffer;
}

std::string ThreeDsBase() {
  return FileUtil::GetUserPath(FileUtil::UserPath::SDMCDir) +
         "Nintendo 3DS/00000000000000000000000000000000/"
         "00000000000000000000000000000000";
}

std::string AppDir(const std::string& path) {
  const auto slash = path.find_last_of('/');
  return slash == std::string::npos ? path : path.substr(0, slash);
}

std::string SaveDir(uint64_t title_id) {
  const std::string hex = TitleIdHexLower(title_id);
  return ThreeDsBase() + "/title/" + hex.substr(0, 8) + "/" + hex.substr(8) + "/data/00000001";
}

std::string UpdatesDir(uint64_t title_id) {
  return ThreeDsBase() + "/title/0004000e/" + TitleIdHexLower(title_id).substr(8) + "/content";
}

std::string DlcDir(uint64_t title_id) {
  return ThreeDsBase() + "/title/0004008c/" + TitleIdHexLower(title_id).substr(8) + "/content";
}

std::string ExtraDir(uint64_t title_id) {
  return ThreeDsBase() + "/extdata/00000000/" + TitleIdHexUpper(title_id).substr(8, 6);
}

std::string ModsDir(uint64_t title_id) {
  return FileUtil::GetUserPath(FileUtil::UserPath::LoadDir) + "mods/" +
         TitleIdHexUpper(title_id);
}

std::string TexturesDir(uint64_t title_id) {
  return FileUtil::GetUserPath(FileUtil::UserPath::LoadDir) + "textures/" +
         TitleIdHexUpper(title_id);
}

std::string FolderPath(uint64_t title_id, const std::string& path, Folder folder) {
  switch (folder) {
  case Folder::App:
    return AppDir(path);
  case Folder::Save:
    return SaveDir(title_id);
  case Folder::Updates:
    return UpdatesDir(title_id);
  case Folder::Dlc:
    return DlcDir(title_id);
  case Folder::Extra:
    return ExtraDir(title_id);
  case Folder::Textures:
    return TexturesDir(title_id);
  case Folder::Mods:
    return ModsDir(title_id);
  }
  return "";
}

}  // namespace

std::array<bool, 7> GetFolderStatus(uint64_t title_id, const std::string& path) {
  EnsureUserPathInitialized();
  return {
      fs::exists(FolderPath(title_id, path, Folder::App)),
      fs::exists(FolderPath(title_id, path, Folder::Save)),
      fs::exists(FolderPath(title_id, path, Folder::Updates)),
      fs::exists(FolderPath(title_id, path, Folder::Dlc)),
      fs::exists(FolderPath(title_id, path, Folder::Extra)),
      true,
      true,
  };
}

bool OpenFolder(uint64_t title_id, const std::string& path, Folder folder) {
  EnsureUserPathInitialized();
  const std::string dir = FolderPath(title_id, path, folder);
  if (folder == Folder::Mods || folder == Folder::Textures) {
    fs::create_directories(dir);
  }
  if (!fs::exists(dir)) {
    return false;
  }

  g_autoptr(GError) error = nullptr;
  g_autoptr(GFile) file = g_file_new_for_path(dir.c_str());
  g_autofree gchar* uri = g_file_get_uri(file);
  const bool launched = g_app_info_launch_default_for_uri(uri, nullptr, &error);
  return launched;
}

bool DeleteFolder(uint64_t title_id, const std::string& path, UninstallTarget target) {
  EnsureUserPathInitialized();
  std::string dir;
  switch (target) {
  case UninstallTarget::Cia:
    dir = AppDir(path);
    break;
  case UninstallTarget::Updates:
    dir = UpdatesDir(title_id);
    break;
  case UninstallTarget::Dlc:
    dir = DlcDir(title_id);
    break;
  }
  std::error_code error;
  return fs::remove_all(dir, error) > 0;
}

void DeleteShaderCache(uint64_t title_id, ShaderBackend backend) {
  EnsureUserPathInitialized();
  const std::string shader_dir = FileUtil::GetUserPath(FileUtil::UserPath::ShaderDir);
  const std::string hex = TitleIdHexUpper(title_id);
  std::error_code error;

  if (backend == ShaderBackend::OpenGL) {
    for (const char* cache_type : {"separable", "conventional"}) {
      fs::remove(shader_dir + "opengl/precompiled/" + cache_type + "/" + hex + ".bin", error);
    }
    fs::remove(shader_dir + "opengl/transferable/" + hex + ".bin", error);
    return;
  }

  for (const char* cache_type : {"vs", "fs", "gs", "pl"}) {
    fs::remove(shader_dir + "vulkan/transferable/" + hex + "_" + cache_type + ".vkch", error);
  }
  const std::string pipeline_dir = shader_dir + "vulkan/pipeline";
  if (fs::exists(pipeline_dir)) {
    for (const auto& entry : fs::directory_iterator(pipeline_dir, error)) {
      if (entry.path().filename().string().starts_with(hex)) {
        fs::remove(entry.path(), error);
      }
    }
  }
}

void CreateShortcut(const std::string& path, const std::string& name,
                     const std::string& icon_file_path, bool stretch) {
  const std::string applications_dir = std::string(g_get_user_data_dir()) + "/applications";
  fs::create_directories(applications_dir);

  char exe_path[4096];
  const ssize_t exe_len = readlink("/proc/self/exe", exe_path, sizeof(exe_path) - 1);
  const std::string executable =
      exe_len > 0 ? std::string(exe_path, exe_len) : "azahar";

  const std::string desktop_path =
      applications_dir + "/azahar-" + std::to_string(std::hash<std::string>{}(path)) + ".desktop";
  std::ofstream file(desktop_path, std::ios::trunc);
  file << "[Desktop Entry]\n";
  file << "Type=Application\n";
  file << "Name=" << name << "\n";
  file << "Exec=" << executable << " --game=\"" << path << "\"\n";
  if (!icon_file_path.empty()) {
    file << "Icon=" << icon_file_path << "\n";
  }
  file << "Terminal=false\n";
  file << "Categories=Game;\n";
}

}  // namespace GameActions
