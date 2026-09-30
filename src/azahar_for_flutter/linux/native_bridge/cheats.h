#ifndef RUNNER_CHEATS_H_
#define RUNNER_CHEATS_H_

#include <cstddef>
#include <cstdint>
#include <string>
#include <vector>

namespace CheatBridge {

/**
 * A snapshot of one cheat held by the core cheat engine.
 */
struct CheatEntry {
  std::string name;
  std::string notes;
  std::string code;
  bool enabled;
};

/**
 * Loads the cheat file of the given title into the core cheat engine.
 */
void LoadCheatFile(uint64_t title_id);

/**
 * Saves the cheats currently held by the core cheat engine for the given title.
 */
void SaveCheatFile(uint64_t title_id);

/**
 * Returns a snapshot of every cheat currently held by the core cheat engine.
 */
std::vector<CheatEntry> GetCheats();

/**
 * Enables or disables the cheat at the given index.
 *
 * @return false when the index is out of range.
 */
bool SetCheatEnabled(std::size_t index, bool enabled);

/**
 * Adds a gateway cheat to the core cheat engine.
 */
void AddCheat(const std::string& name, const std::string& notes, const std::string& code);

/**
 * Validates a gateway code line by line.
 *
 * @return 0 when the code is valid, otherwise the 1-based number of the first invalid line.
 */
int ValidateGatewayCode(const std::string& code);

}  // namespace CheatBridge

#endif  // RUNNER_CHEATS_H_
