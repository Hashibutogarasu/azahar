import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/settings/settings_load_provider.dart';
import 'groups/accessibility_options_group.dart';
import 'groups/clock_options_group.dart';
import 'groups/controls_options_group.dart';
import 'groups/emulation_options_group.dart';
import 'groups/folder_settings_options_group.dart';
import 'groups/general_options_group.dart';
import 'groups/graphics_options_group.dart';
import 'groups/networking_options_group.dart';
import 'groups/other_options_group.dart';
import 'groups/tools_options_group.dart';

/// The Options tab: a grouped settings screen built on `babstrap_settings_screen`. Each category
/// is its own widget under `groups/`, so this file only lays them out in order.
class OptionsPage extends ConsumerWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsLoadProvider);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          GeneralOptionsGroup(),
          EmulationOptionsGroup(),
          ClockOptionsGroup(),
          GraphicsOptionsGroup(),
          NetworkingOptionsGroup(),
          ControlsOptionsGroup(),
          ToolsOptionsGroup(),
          FolderSettingsOptionsGroup(),
          AccessibilityOptionsGroup(),
          OtherOptionsGroup(),
        ],
      ),
    );
  }
}
