#ifndef RUNNER_SYSTEM_SAVE_GAME_H_
#define RUNNER_SYSTEM_SAVE_GAME_H_

#include <cstdint>
#include <string>

namespace SystemSaveGame {

struct Fields {
  std::string username;
  int birthday_month = 0;
  int birthday_day = 0;
  int system_language = 0;
  int sound_output_mode = 0;
  int country_code = 0;
  int play_coins = 0;
  uint64_t console_id = 0;
  std::string mac;
};

struct FieldsUpdate {
  bool has_username = false;
  std::string username;
  bool has_birthday = false;
  int birthday_month = 0;
  int birthday_day = 0;
  bool has_system_language = false;
  int system_language = 0;
  bool has_sound_output_mode = false;
  int sound_output_mode = 0;
  bool has_country_code = false;
  int country_code = 0;
  bool has_play_coins = false;
  int play_coins = 0;
};

Fields Read();
void Write(const FieldsUpdate& update);
std::string RegenerateConsoleId();
std::string RegenerateMac();
int GetCountryCompatibility(int region);
bool IsSystemSetupNeeded();
void SetSystemSetupNeeded(bool needed);

}  // namespace SystemSaveGame

#endif  // RUNNER_SYSTEM_SAVE_GAME_H_
