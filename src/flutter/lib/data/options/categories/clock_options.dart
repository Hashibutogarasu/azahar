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
  (ref) => const OptionCategory(
    id: 'clock',
    titleKey: 'options.groups.clock',
    sections: [
      OptionSection(
        options: [
          EnumOption<int>(
            titleKey: 'settings.system.initClock',
            icon: Icons.list,
            value: StoreIntValue(SystemSettingKeys.initClock),
            choices: [
              EnumChoice(
                labelKey: 'settings.system.initClockDeviceClock',
                value: 0,
              ),
              EnumChoice(
                labelKey: 'settings.system.initClockSimulatedClock',
                value: 1,
              ),
            ],
          ),
          DateTimeOption(
            titleKey: 'settings.system.simulatedClock',
            icon: Icons.schedule,
            value: StoreStringValue(SystemSettingKeys.initTime),
          ),
        ],
      ),
    ],
  ),
);
