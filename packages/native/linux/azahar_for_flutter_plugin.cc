#include "include/azahar_for_flutter/azahar_for_flutter_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gio/gio.h>
#include <gtk/gtk.h>
#include <unistd.h>

#include <array>
#include <cstdint>
#include <exception>
#include <functional>
#include <memory>
#include <optional>
#include <set>
#include <sstream>
#include <string>
#include <thread>
#include <unordered_map>
#include <vector>

#include "native_bridge/cheats.h"
#include "native_bridge/cia_install.h"
#include "native_bridge/emulation.h"
#include "native_bridge/emulator_config.h"
#include "native_bridge/game_actions.h"
#include "native_bridge/gamepad.h"
#include "native_bridge/game_scanner.h"
#include "native_bridge/system_files.h"
#include "native_bridge/system_save_game.h"
#include "native_bridge/user_directory.h"
#include "native_bridge/wifi.h"

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

bool BoolArgument(FlValue* args, const char* key, bool default_value) {
  FlValue* value = fl_value_lookup_string(args, key);
  if (value == nullptr || fl_value_get_type(value) != FL_VALUE_TYPE_BOOL) {
    return default_value;
  }
  return fl_value_get_bool(value);
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

std::vector<GameScanner::InstalledTitlePath> InstalledTitlePathsArgument(FlValue* args) {
  std::vector<GameScanner::InstalledTitlePath> paths;
  FlValue* list_value = fl_value_lookup_string(args, "installedTitlePaths");
  if (list_value == nullptr || fl_value_get_type(list_value) != FL_VALUE_TYPE_LIST) {
    return paths;
  }
  for (std::size_t i = 0; i < fl_value_get_length(list_value); ++i) {
    FlValue* entry = fl_value_get_list_value(list_value, i);
    if (fl_value_get_type(entry) != FL_VALUE_TYPE_MAP) {
      continue;
    }
    const std::string root = StringArgument(entry, "root");
    paths.push_back({root == "nand" ? GameScanner::InstalledTitleRoot::NandDir
                                     : GameScanner::InstalledTitleRoot::SdmcDir,
                      StringArgument(entry, "path")});
  }
  return paths;
}

FlMethodResponse* HandleGetGames(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) games = fl_value_new_list();
  for (const GameScanner::GameEntry& game : GameScanner::ScanGames(
           StringArgument(args, "gamesDirectory"), InstalledTitlePathsArgument(args))) {
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

  g_autoptr(FlValue) results = fl_value_new_list();
  for (const CiaInstall::Result& result : CiaInstall::InstallFiles(paths)) {
    FlValue* entry = fl_value_new_map();
    fl_value_set_string_take(entry, "filename", fl_value_new_string(result.filename.c_str()));
    fl_value_set_string_take(entry, "success", fl_value_new_bool(result.success));
    fl_value_append_take(results, entry);
  }
  return FL_METHOD_RESPONSE(fl_method_success_response_new(results));
}

FlMethodResponse* HandleShowNotification(GtkWindow* window, FlValue* args) {
  GApplication* application =
      G_APPLICATION(gtk_window_get_application(GTK_WINDOW(window)));
  const std::string title = StringArgument(args, "title");
  const std::string body = StringArgument(args, "body");
  if (application != nullptr && !title.empty()) {
    g_autoptr(GNotification) notification = g_notification_new(title.c_str());
    if (!body.empty()) {
      g_notification_set_body(notification, body.c_str());
    }
    g_application_send_notification(application, nullptr, notification);
  }
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

gboolean ExitProcessOnIdle(gpointer user_data) {
  _exit(0);
  return G_SOURCE_REMOVE;
}

FlMethodResponse* HandleTerminateProcess(GtkWindow* window, FlValue* args) {
  gtk_widget_hide(GTK_WIDGET(window));
  g_idle_add(ExitProcessOnIdle, nullptr);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleSetConsoleLogEnabled(GtkWindow* window, FlValue* args) {
  Emulation::SetConsoleLogEnabled(BoolArgument(args, "enabled", true));
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

FlTextureRegistrar* TextureRegistrarForWindow(GtkWindow* window) {
  FlView* view = FL_VIEW(gtk_bin_get_child(GTK_BIN(window)));
  return fl_engine_get_texture_registrar(fl_view_get_engine(view));
}

FlMethodResponse* HandleCreateEmulationTexture(GtkWindow* window, FlValue* args) {
  FlValue* width_value = fl_value_lookup_string(args, "width");
  FlValue* height_value = fl_value_lookup_string(args, "height");
  FlValue* secondary_value = fl_value_lookup_string(args, "secondary");
  const int width =
      width_value != nullptr && fl_value_get_type(width_value) == FL_VALUE_TYPE_INT
          ? static_cast<int>(fl_value_get_int(width_value))
          : 1;
  const int height =
      height_value != nullptr && fl_value_get_type(height_value) == FL_VALUE_TYPE_INT
          ? static_cast<int>(fl_value_get_int(height_value))
          : 1;
  const bool secondary = secondary_value != nullptr &&
                         fl_value_get_type(secondary_value) == FL_VALUE_TYPE_BOOL &&
                         fl_value_get_bool(secondary_value);
  g_autoptr(FlValue) result = fl_value_new_int(
      Emulation::CreateTexture(TextureRegistrarForWindow(window), width, height, secondary));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleStartEmulation(GtkWindow* window, FlValue* args) {
  Emulation::StartEmulation(StringArgument(args, "path"));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandlePauseEmulation(GtkWindow* window, FlValue* args) {
  Emulation::PauseEmulation();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleResumeEmulation(GtkWindow* window, FlValue* args) {
  Emulation::ResumeEmulation();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleAdvanceFrame(GtkWindow* window, FlValue* args) {
  Emulation::AdvanceFrame();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleLoadCheatFile(GtkWindow* window, FlValue* args) {
  CheatBridge::LoadCheatFile(TitleIdArgument(args));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleSaveCheatFile(GtkWindow* window, FlValue* args) {
  CheatBridge::SaveCheatFile(TitleIdArgument(args));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleGetCheats(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) result = fl_value_new_list();
  for (const auto& cheat : CheatBridge::GetCheats()) {
    FlValue* map = fl_value_new_map();
    fl_value_set_string_take(map, "name", fl_value_new_string(cheat.name.c_str()));
    fl_value_set_string_take(map, "notes", fl_value_new_string(cheat.notes.c_str()));
    fl_value_set_string_take(map, "code", fl_value_new_string(cheat.code.c_str()));
    fl_value_set_string_take(map, "enabled", fl_value_new_bool(cheat.enabled));
    fl_value_append_take(result, map);
  }
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleSetCheatEnabled(GtkWindow* window, FlValue* args) {
  FlValue* index = fl_value_lookup_string(args, "index");
  if (index == nullptr || fl_value_get_type(index) != FL_VALUE_TYPE_INT ||
      !CheatBridge::SetCheatEnabled(static_cast<std::size_t>(fl_value_get_int(index)),
                                    BoolArgument(args, "enabled", false))) {
    return FL_METHOD_RESPONSE(
        fl_method_error_response_new("invalid_argument", "invalid cheat index", nullptr));
  }
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleAddCheat(GtkWindow* window, FlValue* args) {
  CheatBridge::AddCheat(StringArgument(args, "name"), StringArgument(args, "notes"),
                        StringArgument(args, "code"));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleValidateCheatCode(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) result =
      fl_value_new_int(CheatBridge::ValidateGatewayCode(StringArgument(args, "code")));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandlePauseRendering(GtkWindow* window, FlValue* args) {
  Emulation::PauseRendering();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleResumeRendering(GtkWindow* window, FlValue* args) {
  Emulation::ResumeRendering();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

gboolean RespondToStopEmulation(gpointer user_data) {
  FlMethodCall* method_call = FL_METHOD_CALL(user_data);
  g_autoptr(FlMethodResponse) response =
      FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
  fl_method_call_respond(method_call, response, nullptr);
  g_object_unref(method_call);
  return G_SOURCE_REMOVE;
}

void HandleStopEmulationAsync(FlMethodCall* method_call) {
  FlMethodCall* call_ref = FL_METHOD_CALL(g_object_ref(method_call));
  std::thread([call_ref] {
    Emulation::StopAndWait();
    g_idle_add(RespondToStopEmulation, call_ref);
  }).detach();
}

double DoubleArgument(FlValue* args, const char* key) {
  FlValue* value = fl_value_lookup_string(args, key);
  if (value == nullptr) {
    return 0;
  }
  if (fl_value_get_type(value) == FL_VALUE_TYPE_FLOAT) {
    return fl_value_get_float(value);
  }
  if (fl_value_get_type(value) == FL_VALUE_TYPE_INT) {
    return static_cast<double>(fl_value_get_int(value));
  }
  return 0;
}

FlMethodResponse* HandleOnTouchEvent(GtkWindow* window, FlValue* args) {
  FlValue* pressed_value = fl_value_lookup_string(args, "pressed");
  const bool pressed = pressed_value != nullptr &&
                       fl_value_get_type(pressed_value) == FL_VALUE_TYPE_BOOL &&
                       fl_value_get_bool(pressed_value);
  g_autoptr(FlValue) result = fl_value_new_bool(Emulation::OnTouchEvent(
      DoubleArgument(args, "x"), DoubleArgument(args, "y"), pressed));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* HandleOnTouchMoved(GtkWindow* window, FlValue* args) {
  Emulation::OnTouchMoved(DoubleArgument(args, "x"), DoubleArgument(args, "y"));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleSendGamePadEvent(GtkWindow* window, FlValue* args) {
  if (!Gamepad::Send(args)) {
    return FL_METHOD_RESPONSE(fl_method_error_response_new(
        "invalid_argument", "unknown gamepad event", nullptr));
  }
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* HandleSwapScreens(GtkWindow* window, FlValue* args) {
  g_autoptr(FlValue) result = fl_value_new_bool(Emulation::SwapScreens());
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
      {"showNotification", HandleShowNotification},
      {"terminateProcess", HandleTerminateProcess},
      {"setConsoleLogEnabled", HandleSetConsoleLogEnabled},
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
      {"hasPermission", HandleHasPermission},
      {"requestPermission", HandleRequestPermission},
      {"createEmulationTexture", HandleCreateEmulationTexture},
      {"startEmulation", HandleStartEmulation},
      {"pauseEmulation", HandlePauseEmulation},
      {"resumeEmulation", HandleResumeEmulation},
      {"advanceFrame", HandleAdvanceFrame},
      {"loadCheatFile", HandleLoadCheatFile},
      {"saveCheatFile", HandleSaveCheatFile},
      {"getCheats", HandleGetCheats},
      {"setCheatEnabled", HandleSetCheatEnabled},
      {"addCheat", HandleAddCheat},
      {"validateCheatCode", HandleValidateCheatCode},
      {"pauseRendering", HandlePauseRendering},
      {"resumeRendering", HandleResumeRendering},
      {"onTouchEvent", HandleOnTouchEvent},
      {"onTouchMoved", HandleOnTouchMoved},
      {"swapScreens", HandleSwapScreens},
      {"sendGamePadEvent", HandleSendGamePadEvent},
  };
  return handlers;
}

void HandleBridgeMethodCall(FlMethodChannel* channel,
                            FlMethodCall* method_call,
                            gpointer user_data) {
  GtkWindow* window = GTK_WINDOW(user_data);
  const std::string name = fl_method_call_get_name(method_call);
  FlValue* args = fl_method_call_get_args(method_call);

  if (name == "stopEmulation") {
    HandleStopEmulationAsync(method_call);
    return;
  }

  const auto& handlers = BridgeMethodHandlers();
  const auto it = handlers.find(name);
  g_autoptr(FlMethodResponse) response = nullptr;
  if (it == handlers.end()) {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  } else {
    try {
      response = it->second(window, args);
    } catch (const std::exception& e) {
      response = FL_METHOD_RESPONSE(
          fl_method_error_response_new("native_exception", e.what(), nullptr));
    } catch (...) {
      response = FL_METHOD_RESPONSE(
          fl_method_error_response_new("native_exception", "unknown exception", nullptr));
    }
  }

  fl_method_call_respond(method_call, response, nullptr);
}
FlMethodErrorResponse* HandleShaderProgressListen(FlEventChannel* channel, FlValue* args,
                                                  gpointer user_data) {
  Emulation::SetShaderProgressChannel(channel);
  return nullptr;
}

FlMethodErrorResponse* HandleShaderProgressCancel(FlEventChannel* channel, FlValue* args,
                                                  gpointer user_data) {
  Emulation::SetShaderProgressChannel(nullptr);
  return nullptr;
}

FlMethodErrorResponse* HandleLogLinesListen(FlEventChannel* channel, FlValue* args,
                                            gpointer user_data) {
  Emulation::SetLogLinesChannel(channel);
  return nullptr;
}

FlMethodErrorResponse* HandleLogLinesCancel(FlEventChannel* channel, FlValue* args,
                                            gpointer user_data) {
  Emulation::SetLogLinesChannel(nullptr);
  return nullptr;
}

FlMethodErrorResponse* HandleGamePadListen(FlEventChannel* channel, FlValue* args,
                                           gpointer user_data) {
  Gamepad::SetEventChannel(channel);
  return nullptr;
}

FlMethodErrorResponse* HandleGamePadCancel(FlEventChannel* channel, FlValue* args,
                                           gpointer user_data) {
  Gamepad::SetEventChannel(nullptr);
  return nullptr;
}

gboolean HandleWindowDeleteEvent(GtkWidget* widget, GdkEvent* event, gpointer user_data) {
  if (!Emulation::IsSessionActive()) {
    return FALSE;
  }
  FlMethodChannel* channel =
      FL_METHOD_CHANNEL(g_object_get_data(G_OBJECT(widget), "bridge_channel"));
  if (channel) {
    fl_method_channel_invoke_method(channel, "requestClose", nullptr, nullptr, nullptr, nullptr);
  }
  return TRUE;
}

void RegisterShaderProgressChannel(FlBinaryMessenger* messenger) {
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  FlEventChannel* channel = fl_event_channel_new(
      messenger, "org.citra.citra_emu/azahar_bridge/shader_progress", FL_METHOD_CODEC(codec));
  fl_event_channel_set_stream_handlers(channel, HandleShaderProgressListen,
                                       HandleShaderProgressCancel, nullptr, nullptr);
}

void RegisterLogLinesChannel(FlBinaryMessenger* messenger) {
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  FlEventChannel* channel = fl_event_channel_new(
      messenger, "org.citra.citra_emu/azahar_bridge/log_lines", FL_METHOD_CODEC(codec));
  fl_event_channel_set_stream_handlers(channel, HandleLogLinesListen, HandleLogLinesCancel,
                                       nullptr, nullptr);
}

void RegisterGamePadChannel(FlBinaryMessenger* messenger) {
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  FlEventChannel* channel = fl_event_channel_new(
      messenger, "org.citra.citra_emu/azahar_bridge/gamepad_events", FL_METHOD_CODEC(codec));
  fl_event_channel_set_stream_handlers(channel, HandleGamePadListen, HandleGamePadCancel,
                                       nullptr, nullptr);
}

}  // namespace

void azahar_for_flutter_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  FlView* view = fl_plugin_registrar_get_view(registrar);
  if (view == nullptr) {
    return;
  }
  GtkWindow* window = GTK_WINDOW(gtk_widget_get_toplevel(GTK_WIDGET(view)));
  FlBinaryMessenger* messenger = fl_plugin_registrar_get_messenger(registrar);

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  FlMethodChannel* bridge_channel =
      fl_method_channel_new(messenger, kBridgeChannel, FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(bridge_channel, HandleBridgeMethodCall, window,
                                            nullptr);
  RegisterShaderProgressChannel(messenger);
  RegisterLogLinesChannel(messenger);
  RegisterGamePadChannel(messenger);
  g_object_set_data(G_OBJECT(window), "bridge_channel", bridge_channel);
  g_signal_connect(window, "delete-event", G_CALLBACK(HandleWindowDeleteEvent), nullptr);
}
