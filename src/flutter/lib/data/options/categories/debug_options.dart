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
    title: (t) => t.settings.debug.title,
    sections: [
      OptionSection(
        options: [
          BoolOption(
            title: (t) => t.settings.debug.logToConsole,
            description: (t) => t.settings.debug.logToConsoleDescription,
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
        title: (t) => t.settings.debug.warning,
        options: [
          PercentOption(
            title: (t) => t.settings.debug.cpuClockSpeed,
            description: (t) => t.settings.debug.cpuClockSpeedDescription,
            icon: Icons.tune,
            value: const IntPercentValue(
              StoreIntValue(DebugSettingKeys.cpuClockSpeed),
            ),
            min: 0.25,
            max: 4.0,
            defaultValue: 1.0,
          ),
          BoolOption(
            title: (t) => t.settings.debug.cpuJit,
            description: (t) => t.settings.debug.cpuJitDescription,
            icon: Icons.memory,
            value: const StoreBoolValue(DebugSettingKeys.cpuJit),
          ),
          BoolOption(
            title: (t) => t.settings.debug.hwShaders,
            description: (t) => t.settings.debug.hwShadersDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(DebugSettingKeys.hwShaders),
          ),
          BoolOption(
            title: (t) => t.settings.debug.vsync,
            description: (t) => t.settings.debug.vsyncDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(DebugSettingKeys.vsync),
          ),
          BoolOption(
            title: (t) => t.settings.debug.rendererDebug,
            description: (t) => t.settings.debug.rendererDebugDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(DebugSettingKeys.rendererDebug),
          ),
          BoolOption(
            title: (t) => t.settings.debug.instantDebugLog,
            description: (t) => t.settings.debug.instantDebugLogDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(DebugSettingKeys.instantDebugLog),
          ),
          BoolOption(
            title: (t) => t.settings.debug.delayStartLleModules,
            description: (t) =>
                t.settings.debug.delayStartLleModulesDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(DebugSettingKeys.delayStartLleModules),
          ),
          BoolOption(
            title: (t) => t.settings.debug.deterministicAsyncOperations,
            description: (t) =>
                t.settings.debug.deterministicAsyncOperationsDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(
              DebugSettingKeys.deterministicAsyncOperations,
            ),
          ),
        ],
      ),
    ],
  ),
);
