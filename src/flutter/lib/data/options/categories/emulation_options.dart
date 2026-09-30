import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../settings/sections/general_settings.dart';
import '../../settings/sections/system_settings.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';
import '../store_option_values.dart';

/// The Emulation category: New 3DS mode, high-level emulation, the frame limit and the plugin
/// loader.
final emulationOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'emulation',
    titleKey: 'options.groups.emulation',
    sections: [
      OptionSection(
        options: [
          const BoolOption(
            titleKey: 'settings.system.new3ds',
            descriptionKey: 'settings.system.new3dsDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(SystemSettingKeys.new3ds),
          ),
          BoolOption(
            titleKey: 'settings.emulation.useHighLevelEmulation',
            descriptionKey:
                'settings.emulation.useHighLevelEmulationDescription',
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
          const BoolOption(
            titleKey: 'settings.general.frameLimitEnable',
            descriptionKey: 'settings.general.frameLimitEnableDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(GeneralSettingKeys.useFrameLimit),
          ),
          IntOption(
            titleKey: 'settings.general.frameLimitSlider',
            descriptionKey: 'settings.general.frameLimitSliderDescription',
            icon: Icons.tune,
            value: const StoreIntValue(GeneralSettingKeys.frameLimit),
            min: 1,
            max: 200,
            defaultValue: GeneralSettingKeys.frameLimit.defaultValue,
            units: '%',
          ),
          const BoolOption(
            titleKey: 'settings.system.pluginLoaderEnable',
            descriptionKey: 'settings.system.pluginLoaderEnableDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(SystemSettingKeys.pluginLoader),
          ),
          const BoolOption(
            titleKey: 'settings.system.allowPluginLoader',
            descriptionKey: 'settings.system.allowPluginLoaderDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(SystemSettingKeys.allowPluginLoader),
          ),
        ],
      ),
    ],
  ),
);
