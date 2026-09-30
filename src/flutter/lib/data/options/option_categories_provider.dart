import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'categories/accessibility_options.dart';
import 'categories/accessibility_settings_options.dart';
import 'categories/advanced_options.dart';
import 'categories/camera_page_options.dart';
import 'categories/clock_options.dart';
import 'categories/controls_options.dart';
import 'categories/controls_settings_options.dart';
import 'categories/debug_options.dart';
import 'categories/emulation_options.dart';
import 'categories/folder_settings_options.dart';
import 'categories/general_options.dart';
import 'categories/graphics_options.dart';
import 'categories/language_options.dart';
import 'categories/layout_page_options.dart';
import 'categories/media_options.dart';
import 'categories/networking_options.dart';
import 'categories/other_options.dart';
import 'categories/profile_options.dart';
import 'categories/renderer_options.dart';
import 'categories/theme_options.dart';
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

/// The categories of the options that live on their own pages rather than on the Options page.
/// They are not listed there, but search, the history and the pinned items reach them.
final optionPageCategoriesProvider = Provider<List<OptionCategory>>(
  (ref) => [
    ref.watch(profileOptionsProvider),
    ref.watch(languageOptionsProvider),
    ref.watch(themeOptionsProvider),
    ref.watch(mediaOptionsProvider),
    ref.watch(rendererOptionsProvider),
    ref.watch(layoutPageOptionsProvider),
    ref.watch(customLandscapeLayoutPageOptionsProvider),
    ref.watch(customPortraitLayoutPageOptionsProvider),
    ref.watch(cameraPageOptionsProvider),
    ref.watch(controlsSettingsOptionsProvider),
    ref.watch(accessibilitySettingsOptionsProvider),
    ref.watch(advancedOptionsProvider),
    ref.watch(debugOptionsProvider),
  ],
);

/// Every item of every category, in display order, followed by the items that live on their own
/// pages.
final optionEntriesProvider = Provider<List<OptionEntry>>(
  (ref) => [
    for (final category in [
      ...ref.watch(optionCategoriesProvider),
      ...ref.watch(optionPageCategoriesProvider),
    ])
      ...category.entries,
  ],
);

/// Looks an item up by the id stored in pins and history.
final optionEntryByIdProvider = Provider<Map<String, OptionEntry>>(
  (ref) => {
    for (final entry in ref.watch(optionEntriesProvider)) entry.id: entry,
  },
);
