#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include <unistd.h>

#include <array>
#include <cstdint>
#include <fstream>
#include <functional>
#include <optional>
#include <set>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

#include "flutter/generated_plugin_registrant.h"
#include "native_bridge/cia_install.h"
#include "native_bridge/emulator_config.h"
#include "native_bridge/game_actions.h"
#include "native_bridge/game_scanner.h"
#include "native_bridge/system_files.h"
#include "native_bridge/system_save_game.h"
#include "native_bridge/user_directory.h"
#include "native_bridge/wifi.h"

struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

namespace {

constexpr char kBridgeChannel[] = "org.citra.citra_emu/azahar_bridge";

std::set<std::string>& GrantedPermissions() {
  static std::set<std::string> granted;
  return granted;
}

gboolean RequestPermissionNatively(GtkWindow* parent,
                                    const std::string& permission) {
  GtkWidget* dialog = gtk_message_dialog_new(
      parent, GTK_DIALOG_MODAL, GTK_MESSAGE_QUESTION, GTK_BUTTONS_YES_NO,
      "Allow azahar to use %s?", permission.c_str());
  gint response = gtk_dialog_run(GTK_DIALOG(dialog));
  gtk_widget_destroy(dialog);
  return response == GTK_RESPONSE_YES;
}

FlValue* GameEntryToFlValue(const GameScanner::GameEntry& game) {
  FlValue* map = fl_value_new_map();
  fl_value_set_string_take(map, "title", fl_value_new_string(game.title.c_str()));
  fl_value_set_string_take(map, "description",
                            fl_value_new_string(game.description.c_str()));
  fl_value_set_string_take(map, "path", fl_value_new_string(game.path.c_str()));
  fl_value_set_string_take(
      map, "titleId", fl_value_new_int(static_cast<int64_t>(game.title_id)));
  fl_value_set_string_take(map, "company", fl_value_new_string(game.company.c_str()));
  fl_value_set_string_take(map, "regions", fl_value_new_string(game.regions.c_str()));
  fl_value_set_string_take(map, "isInstalled", fl_value_new_bool(game.is_installed));
  fl_value_set_string_take(map, "isSystemTitle", fl_value_new_bool(game.is_system_title));
  fl_value_set_string_take(map, "isVisibleSystemTitle",
                            fl_value_new_bool(game.is_visible_system_title));
  fl_value_set_string_take(map, "filename", fl_value_new_string(game.filename.c_str()));
  if (game.icon_path.empty()) {
    fl_value_set_string_take(map, "iconPath", fl_value_new_null());
  } else {
    fl_value_set_string_take(map, "iconPath", fl_value_new_string(game.icon_path.c_str()));
  }
  return map;
}

std::string StringArgument(FlValue* args, const char* key) {
  FlValue* value = fl_value_lookup_string(args, key);
  if (value == nullptr || fl_value_get_type(value) != FL_VALUE_TYPE_STRING) {
    return "";
  }
  return fl_value_get_string(value);
}

FlValue* ConfigSectionsToFlValue(const EmulatorConfig::Sections& sections) {
  FlValue* map = fl_value_new_map();
  for (const auto& [section, keys] : sections) {
    FlValue* keys_map = fl_value_new_map();
    for (const auto& [key, value] : keys) {
      fl_value_set_string_take(keys_map, key.c_str(), fl_value_new_string(value.c_str()));
    }
    fl_value_set_string_take(map, section.c_str(), keys_map);
  }
  return map;
}

EmulatorConfig::Sections FlValueToConfigSections(FlValue* value) {
  EmulatorConfig::Sections sections;
  if (value == nullptr || fl_value_get_type(value) != FL_VALUE_TYPE_MAP) {
    return sections;
  }
  for (std::size_t i = 0; i < fl_value_get_length(value); ++i) {
    FlValue* section_key = fl_value_get_map_key(value, i);
    FlValue* section_value = fl_value_get_map_value(value, i);
    if (fl_value_get_type(section_key) != FL_VALUE_TYPE_STRING ||
        fl_value_get_type(section_value) != FL_VALUE_TYPE_MAP) {
      continue;
    }
    auto& keys = sections[fl_value_get_string(section_key)];
    for (std::size_t j = 0; j < fl_value_get_length(section_value); ++j) {
      FlValue* entry_key = fl_value_get_map_key(section_value, j);
      FlValue* entry_value = fl_value_get_map_value(section_value, j);
      if (fl_value_get_type(entry_key) != FL_VALUE_TYPE_STRING ||
          fl_value_get_type(entry_value) != FL_VALUE_TYPE_STRING) {
        continue;
      }
      keys[fl_value_get_string(entry_key)] = fl_value_get_string(entry_value);
    }
  }
  return sections;
}

FlMethodResponse* HandleReadEmulatorConfig(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) result = ConfigSectionsToFlValue(EmulatorConfig::Read());
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleWriteEmulatorConfig(GtkWindow* window, FlValue* args) {
  EmulatorConfig::Write(FlValueToConfigSections(args));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleReloadEmulatorSettings(GtkWindow* window, FlValue* args) {
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlValue* SystemSaveFieldsToFlValue(const SystemSaveGame::Fields& fields) {
  FlValue* map = fl_value_new_map();
  fl_value_set_string_take(map, "username", fl_value_new_string(fields.username.c_str()));
  fl_value_set_string_take(map, "birthdayMonth", fl_value_new_int(fields.birthday_month));
  fl_value_set_string_take(map, "birthdayDay", fl_value_new_int(fields.birthday_day));
  fl_value_set_string_take(map, "systemLanguage", fl_value_new_int(fields.system_language));
  fl_value_set_string_take(map, "soundOutputMode", fl_value_new_int(fields.sound_output_mode));
  fl_value_set_string_take(map, "countryCode", fl_value_new_int(fields.country_code));
  fl_value_set_string_take(map, "playCoins", fl_value_new_int(fields.play_coins));
  std::ostringstream console_id;
  console_id << "0x" << std::uppercase << std::hex << fields.console_id;
  fl_value_set_string_take(map, "consoleId", fl_value_new_string(console_id.str().c_str()));
  fl_value_set_string_take(map, "mac", fl_value_new_string(fields.mac.c_str()));
  return map;
}

SystemSaveGame::FieldsUpdate FlValueToSystemSaveFieldsUpdate(FlValue* args) {
  SystemSaveGame::FieldsUpdate update;
  if (args == nullptr || fl_value_get_type(args) != FL_VALUE_TYPE_MAP) {
    return update;
  }

  FlValue* username = fl_value_lookup_string(args, "username");
  if (username != nullptr && fl_value_get_type(username) == FL_VALUE_TYPE_STRING) {
    update.has_username = true;
    update.username = fl_value_get_string(username);
  }

  FlValue* birthday_month = fl_value_lookup_string(args, "birthdayMonth");
  FlValue* birthday_day = fl_value_lookup_string(args, "birthdayDay");
  if ((birthday_month != nullptr && fl_value_get_type(birthday_month) == FL_VALUE_TYPE_INT) ||
      (birthday_day != nullptr && fl_value_get_type(birthday_day) == FL_VALUE_TYPE_INT)) {
    update.has_birthday = true;
    const SystemSaveGame::Fields current = SystemSaveGame::Read();
    update.birthday_month = birthday_month != nullptr &&
                                     fl_value_get_type(birthday_month) == FL_VALUE_TYPE_INT
                                 ? static_cast<int>(fl_value_get_int(birthday_month))
                                 : current.birthday_month;
    update.birthday_day = birthday_day != nullptr &&
                                   fl_value_get_type(birthday_day) == FL_VALUE_TYPE_INT
                               ? static_cast<int>(fl_value_get_int(birthday_day))
                               : current.birthday_day;
  }

  FlValue* system_language = fl_value_lookup_string(args, "systemLanguage");
  if (system_language != nullptr && fl_value_get_type(system_language) == FL_VALUE_TYPE_INT) {
    update.has_system_language = true;
    update.system_language = static_cast<int>(fl_value_get_int(system_language));
  }

  FlValue* sound_output_mode = fl_value_lookup_string(args, "soundOutputMode");
  if (sound_output_mode != nullptr && fl_value_get_type(sound_output_mode) == FL_VALUE_TYPE_INT) {
    update.has_sound_output_mode = true;
    update.sound_output_mode = static_cast<int>(fl_value_get_int(sound_output_mode));
  }

  FlValue* country_code = fl_value_lookup_string(args, "countryCode");
  if (country_code != nullptr && fl_value_get_type(country_code) == FL_VALUE_TYPE_INT) {
    update.has_country_code = true;
    update.country_code = static_cast<int>(fl_value_get_int(country_code));
  }

  FlValue* play_coins = fl_value_lookup_string(args, "playCoins");
  if (play_coins != nullptr && fl_value_get_type(play_coins) == FL_VALUE_TYPE_INT) {
    update.has_play_coins = true;
    update.play_coins = static_cast<int>(fl_value_get_int(play_coins));
  }

  return update;
}

FlMethodResponse* HandleReadSystemSaveGame(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) result = SystemSaveFieldsToFlValue(SystemSaveGame::Read());
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleWriteSystemSaveGame(GtkWindow* window, FlValue* args) {
  SystemSaveGame::Write(FlValueToSystemSaveFieldsUpdate(args));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleRegenerateConsoleId(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) result =
      fl_value_new_string(SystemSaveGame::RegenerateConsoleId().c_str());
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleRegenerateMac(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) result = fl_value_new_string(SystemSaveGame::RegenerateMac().c_str());
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleGetCountryCompatibility(GtkWindow* window, FlValue* args) {
  const int region =
      args != nullptr && fl_value_get_type(args) == FL_VALUE_TYPE_INT
          ? static_cast<int>(fl_value_get_int(args))
          : 0;
  g_autoptr(FlValue) result =
      fl_value_new_int(SystemSaveGame::GetCountryCompatibility(region));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleHasUserDirectoryWriteAccess(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) result =
      fl_value_new_bool(access(UserDataDirectory().c_str(), W_OK) == 0);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleGetGames(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) games = fl_value_new_list();
  for (const GameScanner::GameEntry& game :
       GameScanner::ScanGames(StringArgument(args, "gamesDirectory"))) {
    fl_value_append_take(games, GameEntryToFlValue(game));
  }
  return FL_METHOD_RESPONSE(fl_method_success_response_new(games));
}

FlMethodResponse* HandleInstallCiaFiles(GtkWindow* window, FlValue* args) {
  std::vector<std::string> paths;
  FlValue* paths_value = fl_value_lookup_string(args, "paths");
  if (paths_value != nullptr && fl_value_get_type(paths_value) == FL_VALUE_TYPE_LIST) {
    for (std::size_t i = 0; i < fl_value_get_length(paths_value); ++i) {
      FlValue* entry = fl_value_get_list_value(paths_value, i);
      if (fl_value_get_type(entry) == FL_VALUE_TYPE_STRING) {
        paths.push_back(fl_value_get_string(entry));
      }
    }
  }
  CiaInstall::InstallFiles(paths);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleIsFullConsoleLinked(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) result = fl_value_new_bool(SystemFiles::IsFullConsoleLinked());
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleUnlinkConsole(GtkWindow* window, FlValue* args) {
  SystemFiles::UnlinkConsole();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleAreSystemTitlesInstalled(GtkWindow* window, FlValue* args) {
  const auto [old3ds, new3ds] = SystemFiles::AreSystemTitlesInstalled();
  g_autoptr(FlValue) result = fl_value_new_list();
  fl_value_append_take(result, fl_value_new_bool(old3ds));
  fl_value_append_take(result, fl_value_new_bool(new3ds));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleInstallSystemFiles(GtkWindow* window, FlValue* args) {
  FlValue* old3ds_value = fl_value_lookup_string(args, "old3ds");
  const bool old3ds =
      old3ds_value != nullptr && fl_value_get_type(old3ds_value) == FL_VALUE_TYPE_BOOL &&
      fl_value_get_bool(old3ds_value);
  SystemFiles::UninstallSystemFiles(old3ds);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleGetHomeMenuPath(GtkWindow* window, FlValue* args) {
  FlValue* region_value = fl_value_lookup_string(args, "region");
  const int region =
      region_value != nullptr && fl_value_get_type(region_value) == FL_VALUE_TYPE_INT
          ? static_cast<int>(fl_value_get_int(region_value))
          : 0;
  g_autoptr(FlValue) result =
      fl_value_new_string(SystemFiles::GetHomeMenuPath(region).c_str());
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleIsSystemSetupNeeded(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) result = fl_value_new_bool(SystemSaveGame::IsSystemSetupNeeded());
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleSetSystemSetupNeeded(GtkWindow* window, FlValue* args) {
  FlValue* needed_value = fl_value_lookup_string(args, "needed");
  const bool needed = needed_value != nullptr &&
                       fl_value_get_type(needed_value) == FL_VALUE_TYPE_BOOL &&
                       fl_value_get_bool(needed_value);
  SystemSaveGame::SetSystemSetupNeeded(needed);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

uint64_t TitleIdArgument(FlValue* args) {
  FlValue* value = fl_value_lookup_string(args, "titleId");
  if (value == nullptr) {
    return 0;
  }
  if (fl_value_get_type(value) == FL_VALUE_TYPE_INT) {
    return static_cast<uint64_t>(fl_value_get_int(value));
  }
  return 0;
}

FlMethodResponse* HandleGetGameFolderStatus(GtkWindow* window, FlValue* args) {
  const uint64_t title_id = TitleIdArgument(args);
  const std::string path = StringArgument(args, "path");
  const std::array<bool, 7> status = GameActions::GetFolderStatus(title_id, path);
  g_autoptr(FlValue) result = fl_value_new_list();
  for (const bool value : status) {
    fl_value_append_take(result, fl_value_new_bool(value));
  }
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

bool ParseFolder(const std::string& name, GameActions::Folder& out) {
  static const std::unordered_map<std::string, GameActions::Folder> kFolders = {
      {"app", GameActions::Folder::App},         {"save", GameActions::Folder::Save},
      {"updates", GameActions::Folder::Updates}, {"dlc", GameActions::Folder::Dlc},
      {"extra", GameActions::Folder::Extra},     {"textures", GameActions::Folder::Textures},
      {"mods", GameActions::Folder::Mods},
  };
  const auto it = kFolders.find(name);
  if (it == kFolders.end()) {
    return false;
  }
  out = it->second;
  return true;
}

FlMethodResponse* HandleOpenGameFolder(GtkWindow* window, FlValue* args) {
  GameActions::Folder folder;
  bool opened = false;
  if (ParseFolder(StringArgument(args, "folder"), folder)) {
    opened =
        GameActions::OpenFolder(TitleIdArgument(args), StringArgument(args, "path"), folder);
  }
  g_autoptr(FlValue) result = fl_value_new_bool(opened);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleDeleteGameFolder(GtkWindow* window, FlValue* args) {
  static const std::unordered_map<std::string, GameActions::UninstallTarget> kTargets = {
      {"cia", GameActions::UninstallTarget::Cia},
      {"updates", GameActions::UninstallTarget::Updates},
      {"dlc", GameActions::UninstallTarget::Dlc},
  };
  const auto it = kTargets.find(StringArgument(args, "target"));
  bool deleted = false;
  if (it != kTargets.end()) {
    deleted = GameActions::DeleteFolder(TitleIdArgument(args), StringArgument(args, "path"),
                                         it->second);
  }
  g_autoptr(FlValue) result = fl_value_new_bool(deleted);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleDeleteShaderCache(GtkWindow* window, FlValue* args) {
  const GameActions::ShaderBackend backend =
      StringArgument(args, "backend") == "opengl" ? GameActions::ShaderBackend::OpenGL
                                                    : GameActions::ShaderBackend::Vulkan;
  GameActions::DeleteShaderCache(TitleIdArgument(args), backend);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleCreateGameShortcut(GtkWindow* window, FlValue* args) {
  FlValue* stretch_value = fl_value_lookup_string(args, "stretch");
  const bool stretch = stretch_value != nullptr &&
                        fl_value_get_type(stretch_value) == FL_VALUE_TYPE_BOOL &&
                        fl_value_get_bool(stretch_value);
  GameActions::CreateShortcut(StringArgument(args, "path"), StringArgument(args, "name"),
                               StringArgument(args, "iconFilePath"), stretch);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleScanRealWifiAccessPoints(GtkWindow* window, FlValue* args) {
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleSetVirtualAccessPoints(GtkWindow* window, FlValue* args) {
  FlValue* list_value = fl_value_lookup_string(args, "accessPoints");
  if (list_value == nullptr || fl_value_get_type(list_value) != FL_VALUE_TYPE_LIST) {
    Wifi::SetVirtualAccessPoints(std::nullopt);
    return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
  }

  std::vector<Wifi::AccessPoint> access_points;
  for (std::size_t i = 0; i < fl_value_get_length(list_value); ++i) {
    FlValue* entry = fl_value_get_list_value(list_value, i);
    if (fl_value_get_type(entry) != FL_VALUE_TYPE_MAP) {
      continue;
    }
    Wifi::AccessPoint access_point;
    access_point.ssid = StringArgument(entry, "ssid");
    access_point.bssid = StringArgument(entry, "bssid");
    FlValue* channel_value = fl_value_lookup_string(entry, "channel");
    FlValue* level_value = fl_value_lookup_string(entry, "level");
    access_point.channel = channel_value != nullptr &&
                                    fl_value_get_type(channel_value) == FL_VALUE_TYPE_INT
                                ? static_cast<int>(fl_value_get_int(channel_value))
                                : 0;
    access_point.level = level_value != nullptr &&
                                  fl_value_get_type(level_value) == FL_VALUE_TYPE_INT
                              ? static_cast<int>(fl_value_get_int(level_value))
                              : 0;
    access_points.push_back(std::move(access_point));
  }
  Wifi::SetVirtualAccessPoints(std::move(access_points));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleSupportsCustomDriverLoading(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) result = fl_value_new_bool(false);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleListGpuDrivers(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) result = fl_value_new_list();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleGetSelectedGpuDriver(GtkWindow* window, FlValue* args) {
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleInstallGpuDriver(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) result = fl_value_new_bool(false);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleSelectGpuDriver(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) result = fl_value_new_bool(false);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleShareLog(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) result = fl_value_new_bool(false);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleHasPermission(GtkWindow* window, FlValue* args) {
  const std::string permission = StringArgument(args, "permission");
  g_autoptr(FlValue) result =
      fl_value_new_bool(GrantedPermissions().count(permission) > 0);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleRequestPermission(GtkWindow* window, FlValue* args) {
  const std::string permission = StringArgument(args, "permission");
  const bool granted = RequestPermissionNatively(window, permission);
  if (granted) {
    GrantedPermissions().insert(permission);
  } else {
    GrantedPermissions().erase(permission);
  }
  g_autoptr(FlValue) result = fl_value_new_bool(granted);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

using BridgeMethodHandler = std::function<FlMethodResponse*(GtkWindow*, FlValue*)>;

const std::unordered_map<std::string, BridgeMethodHandler>& BridgeMethodHandlers() {
  static const std::unordered_map<std::string, BridgeMethodHandler> handlers = {
      {"hasUserDirectoryWriteAccess", HandleHasUserDirectoryWriteAccess},
      {"getGames", HandleGetGames},
      {"readEmulatorConfig", HandleReadEmulatorConfig},
      {"writeEmulatorConfig", HandleWriteEmulatorConfig},
      {"reloadEmulatorSettings", HandleReloadEmulatorSettings},
      {"readSystemSaveGame", HandleReadSystemSaveGame},
      {"writeSystemSaveGame", HandleWriteSystemSaveGame},
      {"regenerateConsoleId", HandleRegenerateConsoleId},
      {"regenerateMac", HandleRegenerateMac},
      {"getCountryCompatibility", HandleGetCountryCompatibility},
      {"installCiaFiles", HandleInstallCiaFiles},
      {"isFullConsoleLinked", HandleIsFullConsoleLinked},
      {"unlinkConsole", HandleUnlinkConsole},
      {"areSystemTitlesInstalled", HandleAreSystemTitlesInstalled},
      {"installSystemFiles", HandleInstallSystemFiles},
      {"getHomeMenuPath", HandleGetHomeMenuPath},
      {"isSystemSetupNeeded", HandleIsSystemSetupNeeded},
      {"setSystemSetupNeeded", HandleSetSystemSetupNeeded},
      {"getGameFolderStatus", HandleGetGameFolderStatus},
      {"openGameFolder", HandleOpenGameFolder},
      {"deleteGameFolder", HandleDeleteGameFolder},
      {"deleteShaderCache", HandleDeleteShaderCache},
      {"createGameShortcut", HandleCreateGameShortcut},
      {"scanRealWifiAccessPoints", HandleScanRealWifiAccessPoints},
      {"setVirtualAccessPoints", HandleSetVirtualAccessPoints},
      {"supportsCustomDriverLoading", HandleSupportsCustomDriverLoading},
      {"listGpuDrivers", HandleListGpuDrivers},
      {"getSelectedGpuDriver", HandleGetSelectedGpuDriver},
      {"installGpuDriver", HandleInstallGpuDriver},
      {"selectGpuDriver", HandleSelectGpuDriver},
      {"shareLog", HandleShareLog},
      {"hasPermission", HandleHasPermission},
      {"requestPermission", HandleRequestPermission},
  };
  return handlers;
}

void HandleBridgeMethodCall(FlMethodChannel* channel,
                            FlMethodCall* method_call,
                            gpointer user_data) {
  GtkWindow* window = GTK_WINDOW(user_data);
  const std::string name = fl_method_call_get_name(method_call);
  FlValue* args = fl_method_call_get_args(method_call);

  const auto& handlers = BridgeMethodHandlers();
  const auto it = handlers.find(name);
  g_autoptr(FlMethodResponse) response =
      it != handlers.end()
          ? it->second(window, args)
          : FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());

  fl_method_call_respond(method_call, response, nullptr);
}

std::string CurrentExecutablePath() {
  char exe_path[4096];
  const ssize_t exe_len = readlink("/proc/self/exe", exe_path, sizeof(exe_path) - 1);
  return exe_len > 0 ? std::string(exe_path, exe_len) : "";
}

std::string ReadFile(const std::string& path) {
  std::ifstream file(path);
  std::ostringstream contents;
  contents << file.rdbuf();
  return contents.str();
}

void ReplaceAll(std::string& text, const std::string& from, const std::string& to) {
  for (std::size_t pos = text.find(from); pos != std::string::npos; pos = text.find(from, pos)) {
    text.replace(pos, from.size(), to);
    pos += to.size();
  }
}

void EnsureDesktopEntryInstalled() {
  const std::string executable = CurrentExecutablePath();
  if (executable.empty()) {
    return;
  }
  const std::string bundle_dir = executable.substr(0, executable.find_last_of('/'));
  const std::string template_path = bundle_dir + "/azahar.desktop.in";
  std::string entry = ReadFile(template_path);
  if (entry.empty()) {
    return;
  }

  const std::string icon_path =
      bundle_dir + "/data/flutter_assets/assets/images/azahar_logo.png";
  ReplaceAll(entry, "@AZAHAR_EXEC@", executable);
  ReplaceAll(entry, "@AZAHAR_ICON@", icon_path);

  const std::string applications_dir = std::string(g_get_user_data_dir()) + "/applications";
  g_mkdir_with_parents(applications_dir.c_str(), 0700);
  const std::string desktop_path =
      applications_dir + "/" + std::string(APPLICATION_ID) + ".desktop";
  std::ofstream(desktop_path, std::ios::trunc) << entry;
}

}  // namespace

// Called when first Flutter frame received.
static void first_frame_cb(MyApplication* self, FlView* view) {
  gtk_widget_show(gtk_widget_get_toplevel(GTK_WIDGET(view)));
}

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);
  EnsureDesktopEntryInstalled();
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  // Use a header bar when running in GNOME as this is the common style used
  // by applications and is the setup most users will be using (e.g. Ubuntu
  // desktop).
  // If running on X and not using GNOME then just use a traditional title bar
  // in case the window manager does more exotic layout, e.g. tiling.
  // If running on Wayland assume the header bar will work (may need changing
  // if future cases occur).
  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen* screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar* wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0) {
      use_header_bar = FALSE;
    }
  }
#endif
  if (use_header_bar) {
    GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, "azahar");
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  } else {
    gtk_window_set_title(window, "azahar");
  }

  gtk_window_set_default_size(window, 1280, 720);

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(
      project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  GdkRGBA background_color;
  // Background defaults to black, override it here if necessary, e.g. #00000000
  // for transparent.
  gdk_rgba_parse(&background_color, "#000000");
  fl_view_set_background_color(view, &background_color);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  // Show the window when Flutter renders.
  // Requires the view to be realized so we can start rendering.
  g_signal_connect_swapped(view, "first-frame", G_CALLBACK(first_frame_cb),
                           self);
  gtk_widget_realize(GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  FlBinaryMessenger* messenger =
      fl_engine_get_binary_messenger(fl_view_get_engine(view));
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  FlMethodChannel* bridge_channel = fl_method_channel_new(
      messenger, kBridgeChannel, FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(
      bridge_channel, HandleBridgeMethodCall, window, nullptr);

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication* application,
                                                  gchar*** arguments,
                                                  int* exit_status) {
  MyApplication* self = MY_APPLICATION(application);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error)) {
    g_warning("Failed to register: %s", error->message);
    *exit_status = 1;
    return TRUE;
  }

  g_application_activate(application);
  *exit_status = 0;

  return TRUE;
}

// Implements GApplication::startup.
static void my_application_startup(GApplication* application) {
  // MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application startup.

  G_APPLICATION_CLASS(my_application_parent_class)->startup(application);
}

// Implements GApplication::shutdown.
static void my_application_shutdown(GApplication* application) {
  // MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application shutdown.

  G_APPLICATION_CLASS(my_application_parent_class)->shutdown(application);
}

// Implements GObject::dispose.
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line =
      my_application_local_command_line;
  G_APPLICATION_CLASS(klass)->startup = my_application_startup;
  G_APPLICATION_CLASS(klass)->shutdown = my_application_shutdown;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication* self) {}

MyApplication* my_application_new() {
  // Set the program name to the application ID, which helps various systems
  // like GTK and desktop environments map this running application to its
  // corresponding .desktop file. This ensures better integration by allowing
  // the application to be recognized beyond its binary name.
  g_set_prgname(APPLICATION_ID);

  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID, "flags",
                                     G_APPLICATION_NON_UNIQUE, nullptr));
}
