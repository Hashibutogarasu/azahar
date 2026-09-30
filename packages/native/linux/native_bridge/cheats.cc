#include "cheats.h"

#include <memory>

#include "common/string_util.h"
#include "core/cheats/cheat_base.h"
#include "core/cheats/cheats.h"
#include "core/cheats/gateway_cheat.h"
#include "core/core.h"
#include "user_directory.h"

namespace CheatBridge {

namespace {

Cheats::CheatEngine& Engine() {
  return Core::System::GetInstance().CheatEngine();
}

}  // namespace

void LoadCheatFile(uint64_t title_id) {
  EnsureUserPathInitialized();
  Engine().LoadCheatFile(title_id);
}

void SaveCheatFile(uint64_t title_id) {
  EnsureUserPathInitialized();
  Engine().SaveCheatFile(title_id);
}

std::vector<CheatEntry> GetCheats() {
  std::vector<CheatEntry> entries;
  for (const auto& cheat : Engine().GetCheats()) {
    entries.push_back({cheat->GetName(), cheat->GetComments(), cheat->GetCode(),
                       cheat->IsEnabled()});
  }
  return entries;
}

bool SetCheatEnabled(std::size_t index, bool enabled) {
  const auto cheats = Engine().GetCheats();
  if (index >= cheats.size()) {
    return false;
  }
  cheats[index]->SetEnabled(enabled);
  return true;
}

void AddCheat(const std::string& name, const std::string& notes, const std::string& code) {
  Engine().AddCheat(std::make_shared<Cheats::GatewayCheat>(name, code, notes));
}

int ValidateGatewayCode(const std::string& code) {
  const auto lines = Common::SplitString(code, '\n');
  for (std::size_t i = 0; i < lines.size(); ++i) {
    const Cheats::GatewayCheat::CheatLine line(lines[i]);
    if (!line.valid) {
      return static_cast<int>(i) + 1;
    }
  }
  return 0;
}

}  // namespace CheatBridge
