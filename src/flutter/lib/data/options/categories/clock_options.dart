import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/sections/system_settings.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../store_option_values.dart';

/// The Clock category: whether the console uses the device clock or a simulated one, and the
/// simulated time.
final clockOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'clock',
    title: (t) => t.options.groups.clock,
    sections: [
      OptionSection(
        options: [
          EnumOption<int>(
            title: (t) => t.settings.system.initClock,
            icon: Icons.list,
            value: const StoreIntValue(SystemSettingKeys.initClock),
            choices: [
              EnumChoice(
                label: (t) => t.settings.system.initClockDeviceClock,
                value: 0,
              ),
              EnumChoice(
                label: (t) => t.settings.system.initClockSimulatedClock,
                value: 1,
              ),
            ],
          ),
          DateTimeOption(
            title: (t) => t.settings.system.simulatedClock,
            icon: Icons.schedule,
            value: const StoreStringValue(SystemSettingKeys.initTime),
          ),
        ],
      ),
    ],
  ),
);
