#ifndef RUNNER_EMULATOR_CONFIG_H_
#define RUNNER_EMULATOR_CONFIG_H_

#include <map>
#include <string>

namespace EmulatorConfig {

using Sections = std::map<std::string, std::map<std::string, std::string>>;

Sections Read();
void Write(const Sections& sections);

}  // namespace EmulatorConfig

#endif  // RUNNER_EMULATOR_CONFIG_H_
