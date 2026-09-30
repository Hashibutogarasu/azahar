import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'categories/accessibility_options.dart';
import 'categories/clock_options.dart';
import 'categories/controls_options.dart';
import 'categories/emulation_options.dart';
import 'categories/folder_settings_options.dart';
import 'categories/general_options.dart';
import 'categories/graphics_options.dart';
import 'categories/networking_options.dart';
import 'categories/other_options.dart';
import 'categories/tools_options.dart';
import 'option_category.dart';
import 'option_entry.dart';

/// The categories listed on the Options page, in display order.
final optionCategoriesProvider = Provider<List<OptionCategory>>(
  (ref) => [
    ref.watch(generalOptionsProvider),
    ref.watch(emulationOptionsProvider),
    ref.watch(clockOptionsProvider),
    ref.watch(graphicsOptionsProvider),
    ref.watch(networkingOptionsProvider),
    ref.watch(controlsOptionsProvider),
    ref.watch(toolsOptionsProvider),
    ref.watch(folderSettingsOptionsProvider),
    ref.watch(accessibilityOptionsProvider),
    ref.watch(otherOptionsProvider),
  ],
);

/// Every item of every category, in display order.
final optionEntriesProvider = Provider<List<OptionEntry>>(
  (ref) => [
    for (final category in ref.watch(optionCategoriesProvider))
      ...category.entries,
  ],
);

/// Looks an item up by the id stored in pins and history.
final optionEntryByIdProvider = Provider<Map<String, OptionEntry>>(
  (ref) => {
    for (final entry in ref.watch(optionEntriesProvider)) entry.id: entry,
  },
);
