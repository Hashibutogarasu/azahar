import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/debug_settings_provider.dart';
import '../../settings/sections/debug_settings.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';
import '../store_option_values.dart';

/// The items of the debug settings page, which is not listed on the Options page: the console log
/// switch, followed by the settings under the warning heading.
final debugOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'debug',
    titleKey: 'settings.debug.title',
    sections: [
      OptionSection(
        options: [
          BoolOption(
            titleKey: 'settings.debug.logToConsole',
            descriptionKey: 'settings.debug.logToConsoleDescription',
            icon: Icons.terminal,
            value: CallbackOptionValue<bool>(
              onRead: (ref) =>
                  ref.watch(debugSettingsProvider).value?.logToConsole ?? false,
              onWrite: (context, ref, value) => ref
                  .read(debugSettingsProvider.notifier)
                  .setLogToConsole(value),
            ),
          ),
        ],
      ),
      OptionSection(
        titleKey: 'settings.debug.warning',
        options: [
          IntOption(
            titleKey: 'settings.debug.cpuClockSpeed',
            descriptionKey: 'settings.debug.cpuClockSpeedDescription',
            icon: Icons.tune,
            value: StoreIntValue(DebugSettingKeys.cpuClockSpeed),
            min: 25,
            max: 400,
            defaultValue: 100,
            units: '%',
          ),
          BoolOption(
            titleKey: 'settings.debug.cpuJit',
            descriptionKey: 'settings.debug.cpuJitDescription',
            icon: Icons.memory,
            value: StoreBoolValue(DebugSettingKeys.cpuJit),
          ),
          BoolOption(
            titleKey: 'settings.debug.hwShaders',
            descriptionKey: 'settings.debug.hwShadersDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(DebugSettingKeys.hwShaders),
          ),
          BoolOption(
            titleKey: 'settings.debug.vsync',
            descriptionKey: 'settings.debug.vsyncDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(DebugSettingKeys.vsync),
          ),
          BoolOption(
            titleKey: 'settings.debug.rendererDebug',
            descriptionKey: 'settings.debug.rendererDebugDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(DebugSettingKeys.rendererDebug),
          ),
          BoolOption(
            titleKey: 'settings.debug.instantDebugLog',
            descriptionKey: 'settings.debug.instantDebugLogDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(DebugSettingKeys.instantDebugLog),
          ),
          BoolOption(
            titleKey: 'settings.debug.delayStartLleModules',
            descriptionKey: 'settings.debug.delayStartLleModulesDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(DebugSettingKeys.delayStartLleModules),
          ),
          BoolOption(
            titleKey: 'settings.debug.deterministicAsyncOperations',
            descriptionKey:
                'settings.debug.deterministicAsyncOperationsDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(
              DebugSettingKeys.deterministicAsyncOperations,
            ),
          ),
        ],
      ),
    ],
  ),
);
