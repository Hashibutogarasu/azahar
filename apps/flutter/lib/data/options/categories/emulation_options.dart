import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../settings/sections/general_settings.dart';
import '../../settings/sections/system_settings.dart';
import '../abstract_base_option.dart';
import '../emulator/settings/emulation_speed_setting.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';
import '../store_option_values.dart';

/// The Emulation category: New 3DS mode, high-level emulation, the frame limit and the plugin
/// loader.
final emulationOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'emulation',
    title: (t) => t.options.groups.emulation,
    sections: [
      OptionSection(
        options: [
          BoolOption(
            title: (t) => t.settings.system.new3ds,
            description: (t) => t.settings.system.new3dsDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(SystemSettingKeys.new3ds),
          ),
          BoolOption(
            title: (t) => t.settings.emulation.useHighLevelEmulation,
            description: (t) =>
                t.settings.emulation.useHighLevelEmulationDescription,
            icon: Icons.toggle_on_outlined,
            value: CallbackOptionValue<bool>(
              onRead: (ref) => !AppServices.emulatorSettingsRepository.readBool(
                SystemSettingKeys.lleApplets,
              ),
              onWrite: (context, ref, value) async {
                await AppServices.emulatorSettingsRepository.writeBool(
                  SystemSettingKeys.lleApplets,
                  !value,
                );
                await AppServices.emulatorSettingsRepository.save();
              },
            ),
          ),
          BoolOption(
            title: (t) => t.settings.general.frameLimitEnable,
            description: (t) => t.settings.general.frameLimitEnableDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(GeneralSettingKeys.useFrameLimit),
          ),
          EmulatorPercentOption(
            title: (t) => t.settings.general.frameLimitSlider,
            description: (t) => t.settings.general.frameLimitSliderDescription,
            icon: Icons.tune,
            setting: const EmulationSpeedSetting(),
            min: EmulationSpeedSetting.minSpeed,
            max: EmulationSpeedSetting.maxSpeed,
            defaultValue: GeneralSettingKeys.frameLimit.defaultValue / 100,
          ),
          BoolOption(
            title: (t) => t.settings.system.pluginLoaderEnable,
            description: (t) => t.settings.system.pluginLoaderEnableDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(SystemSettingKeys.pluginLoader),
          ),
          BoolOption(
            title: (t) => t.settings.system.allowPluginLoader,
            description: (t) => t.settings.system.allowPluginLoaderDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(SystemSettingKeys.allowPluginLoader),
          ),
        ],
      ),
    ],
  ),
);
