#include "system_save_game.h"

#include <iomanip>
#include <sstream>

#include "common/file_util.h"
#include "common/settings.h"
#include "common/string_util.h"
#include "core/core.h"
#include "core/hle/service/cfg/cfg.h"
#include "core/hle/service/ptm/ptm.h"
#include "core/hw/unique_data.h"
#include "user_directory.h"

namespace SystemSaveGame {

namespace {

std::shared_ptr<Service::CFG::Module> Cfg() {
  static std::shared_ptr<Service::CFG::Module> cfg = [] {
    EnsureUserPathInitialized();
    return Service::CFG::GetModule(Core::System::GetInstance());
  }();
  return cfg;
}

std::string ToHexId(uint64_t console_id) {
  std::ostringstream stream;
  stream << "0x" << std::uppercase << std::hex << console_id;
  return stream.str();
}

}  // namespace

Fields Read() {
  const auto cfg = Cfg();
  Fields fields;
  fields.username = Common::UTF16ToUTF8(cfg->GetUsername());
  const auto [month, day] = cfg->GetBirthday();
  fields.birthday_month = month;
  fields.birthday_day = day;
  fields.system_language = static_cast<int>(cfg->GetSystemLanguage());
  fields.sound_output_mode = static_cast<int>(cfg->GetSoundOutputMode());
  fields.country_code = cfg->GetCountryCode();
  fields.play_coins = Service::PTM::Module::GetPlayCoins();
  fields.console_id = cfg->GetConsoleUniqueId();
  fields.mac = cfg->GetMacAddress();
  return fields;
}

void Write(const FieldsUpdate& update) {
  const auto cfg = Cfg();
  if (update.has_username) {
    cfg->SetUsername(Common::UTF8ToUTF16(update.username));
  }
  if (update.has_birthday) {
    cfg->SetBirthday(static_cast<u8>(update.birthday_month),
                      static_cast<u8>(update.birthday_day));
  }
  if (update.has_system_language) {
    cfg->SetSystemLanguage(
        static_cast<Service::CFG::SystemLanguage>(update.system_language));
  }
  if (update.has_sound_output_mode) {
    cfg->SetSoundOutputMode(
        static_cast<Service::CFG::SoundOutputMode>(update.sound_output_mode));
  }
  if (update.has_country_code) {
    cfg->SetCountryCode(static_cast<u8>(update.country_code));
  }
  if (update.has_play_coins) {
    Service::PTM::Module::SetPlayCoins(static_cast<u16>(update.play_coins));
  }
  cfg->UpdateConfigNANDSavegame();
}

std::string RegenerateConsoleId() {
  const auto cfg = Cfg();
  const auto [random_number, console_id] = cfg->GenerateConsoleUniqueId();
  cfg->SetConsoleUniqueId(random_number, console_id);
  return ToHexId(cfg->GetConsoleUniqueId());
}

std::string RegenerateMac() {
  const auto cfg = Cfg();
  cfg->GetMacAddress() = Service::CFG::GenerateRandomMAC();
  cfg->SaveMacAddress();
  return cfg->GetMacAddress();
}

int GetCountryCompatibility(int region) {
  const auto cfg = Cfg();
  int result = 0;
  const u8 country = cfg->GetCountryCode();
  if (region != Settings::REGION_VALUE_AUTO_SELECT &&
      !Service::CFG::Module::IsValidRegionCountry(static_cast<u32>(region), country)) {
    result |= 1;
  }
  if (HW::UniqueData::GetSecureInfoA().IsValid()) {
    region = static_cast<int>(cfg->GetRegionValue(true));
    if (!Service::CFG::Module::IsValidRegionCountry(static_cast<u32>(region), country)) {
      result |= 2;
    }
  }
  return result;
}

bool IsSystemSetupNeeded() {
  return Cfg()->IsSystemSetupNeeded();
}

void SetSystemSetupNeeded(bool needed) {
  Cfg()->SetSystemSetupNeeded(needed);
}

}  // namespace SystemSaveGame
